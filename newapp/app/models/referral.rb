class Referral < ActiveRecord::Base
  validates_presence_of     :name
  validates_format_of       :email, 
                            :with => /^(([\w.%-]+)@((?:[-a-z0-9]+\.)+[a-z]{2,}))?$/i, 
                            :message => "You have entered an invalid email address."
  validates_uniqueness_of   :webpage_address, :allow_nil=>true
  before_save :render_webpage
    
private
  def render_webpage
    self.webpage_html = RedCloth.new(self.webpage_text).to_html unless self.webpage_text.blank?
  end
end
