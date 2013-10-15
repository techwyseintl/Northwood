class Contact < ActiveRecord::Base

  belongs_to  :user
  has_many    :reminders, :order => 'remind_on', :dependent => :destroy
  has_many    :subscriptions, :dependent => :destroy
  has_many    :newsletters, :through => :subscriptions 
  
  validates_presence_of     :first_name, :last_name
  
  # Validates the email only if it's not empty
  validates_format_of       :email, 
	                          :with => /^([\w.%-]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, 
                            :message => "You have entered an invalid email address."                            
                            # This validates the email only if if is not empty
                            # Not sure if we actually need this
                            #:if => Proc.new { |user| !user.email.to_s.empty? }
                            
  validates_uniqueness_of   :email, :case_sensitive => false
  validate                  :applicant_how_did_you_hear_about_us_text
    
  def applicant_how_did_you_hear_about_us_text
    if (pre_approval_notes[:applicant_how_did_you_hear_about_us] == "Other") && (pre_approval_notes[:applicant_how_did_you_hear_about_us_text].empty?)
      errors.add_to_base("Please provide details as to how you heard about us.")
    end
  end
    
    
  attr_accessor :subscribes_to, :pre_approval_notes
    
  def pre_approval_notes
    @pre_approval_notes ||= Hash.new
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end

  def self.purpose_of_loan_options
    ['Purchase', 'Debt Consolidation', 'Transfer Mortgage', 'Renovations', 'Other']
  end
  
  def self.type_of_income_options
    ['Salaried', 'Commission', 'Self Employed', 'Pension', 'Other']
  end

  def self.how_did_you_hear_about_us_options
    [['Choose one', ''],['590 FAN AM', '590 FAN AM'], ['640 AM','640 AM'], ['680 AM', '680 AM'], ['CFRB 1010 AM', 'CFRB 1010 AM'], ['JACKfm (92.5)', 'JACKfm (92.5)'], ['Toronto Sun', 'Toronto Sun'], ['Google', 'Google'], ['Msn', 'Msn'], ['Yahoo', 'Yahoo'], ['Yellow Pages', 'Yellow Pages'], ['Other', 'Other'], ['None', 'None']]
  end

  def update_attributes_if_not_empty(params) 
    @notes_params = Hash.new
    params.each do |name, value| 
      if !self.send(name) || (self.send(name) && self.send(name).empty?)
        self.send("#{name}=", value) 
      else
        @notes_params[name] = value if self.send(name) != value
      end
    end
    save
  end
        
  def before_save
    if pre_approval_notes && !pre_approval_notes.empty?
      message  = "Pre-Approval Application submitted:\n"
      message += textify(@notes_params)           if @notes_params
      message += textify(pre_approval_notes.sort) if pre_approval_notes
      append_to_notes(message)
    end
  end

  def after_save
    save_subscriptions
  end

  def after_update
    delete_subscriptions
  end         
                                               
  def after_destroy
    delete_subscriptions
  end
  
  # Add new subscriptions to the contact
  def save_subscriptions()
    if subscribes_to
      subscribes_to.each do |newsletter_id, value| 
        Subscription.create(:contact_id=>self.id, :newsletter_id=>newsletter_id) if value=='1'
      end
    end
  end

  # Remove all the current subscriptions  
  def delete_subscriptions
      self.subscriptions.each {|subscription| subscription.destroy}
  end
  
  def append_to_notes(text)
    self.notes ||= "" 
    self.notes += "\n------- #{Time.now.to_s :default} ------\n#{text}\n"
  end

  def textify(item)
    message = ''
    item.each  {|name, value| message += "#{name.to_s.split('_').each{|s| s.capitalize!}.join(' ')}: #{value}\n"}
    message
  end
  
end
