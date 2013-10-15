require 'digest/sha1'
class User < ActiveRecord::Base
  
  has_many :contacts
  has_many :reminders, :through => :contacts
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :email, :first_name, :last_name
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email, :case_sensitive => false
  validates_uniqueness_of   :webpage_address, :allow_nil=>true
	validates_format_of       :email, 
	                          :with => /^([\w.%-]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, 
                            :message => "You have entered an invalid email address."
  before_save :encrypt_password
  before_save Proc.new{|user| user.started_on=Time.now if user.started_on.nil?}
  
  # File column configuration
  file_column :photo, 
              :root_path => ENV["RAILS_ENV"] == "test" ? File.join(RAILS_ROOT, "public", "test") : File.join(RAILS_ROOT, "public"),
              :magick => {
                :geometry => "150x150>"
              }
  validates_file_format_of  :photo, :in => ["gif", "png", "jpg"]
  validates_filesize_of     :photo, :in => 0..1.megabyte
  
  
  
  # encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password) && is_active?
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  def is_admin?
    role == ADMIN || role == NOTIFIED_ADMIN || role == ADMIN_ONLY
  end

  def is_active?
    is_active == 1
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end

  def name_for_header(current_user)
    if self.id != current_user.id
      "#{self.first_name}'s"
    else
      "My"
    end
  end
  
  def short_email
    email[0..9]+'...' unless email.size<=12
  end
  
  # Generates a random password, code adapted from http://www.bigbold.com/snippets/posts/show/2137
  def generate_password(size=3)
    consonant = %w(b c d f g h j k l m n p qu r s t v w x z ch cr fr nd ng nk nt ph pr rd sh sl sp st th tr)
    vowel = %w(a e i o u y)
    flipper, password = true, ''
    (size * 2).times do
      password << (flipper ? consonant[rand * consonant.size] : vowel[rand * vowel.size])
      flipper = !flipper
    end
    password
  end
  
  # Generates a new password, and then sets to it
  def save_new_password
    new_password = self.password = self.password_confirmation = self.generate_password
    return (self.save) ? new_password : false
  end
  
  
  def named_user_role
    User.named_user_roles[role]
  end
  
  
  
  
  class << self
    
    def for_select
      User.find(:all, :order => :first_name).collect {|u| [u.full_name, u.id ]}
    end
    
    def named_user_roles
      { 
        ROLE[ADMIN] => 'Administrator',
        ROLE[NOTIFIED_ADMIN] => 'Notified Administrator',
        ROLE[REGULAR_USER] => 'Regular User'
      }
    end

    def notified_admins
      find(:all, :conditions => "role = #{NOTIFIED_ADMIN}")
    end

    def admins
      find(:all, :conditions => "role = #{ADMIN}")
    end
    
    
    # Authenticates a user by their email and unencrypted password.  Returns the user or nil.
    def authenticate(email, password)
      u = find_by_email(email) # need to get the salt
      u && u.authenticated?(password) ? u : nil
    end
    
    # Encrypts some data with the salt.
    def encrypt(password, salt)
      Digest::SHA1.hexdigest("--#{salt}--#{password}--")
    end
    
  end
    
  
  
  
  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end

    
end
