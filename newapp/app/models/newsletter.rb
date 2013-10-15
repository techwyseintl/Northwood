class Newsletter < ActiveRecord::Base
  has_many :subscriptions
  has_many :subscribers, :through => :subscriptions, :source => :contact
  has_many :issues, :class_name => 'NewsletterIssue'


  attr_accessor :tmp_contact_id, :email
  
  def prepare(contact_id)
    self.tmp_contact_id = contact_id
  end
  
  def has_subscription_from
    self.subscriptions.find_by_contact_id(tmp_contact_id) != nil
  end
  
  def can_be_edited?
    self.id != 1
  end
  
  def after_destroy
    self.subscriptions.each {|subscription| subscription.destroy}
    self.issues.each {|issue| issue.destroy}
  end
end
