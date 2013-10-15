class ContactNotifier < ActionMailer::Base
  
  include MailerSupport
  helper ApplicationHelper
  
  def pre_approval(contact)
    setup_email(contact)
    @subject          = "Your Pre-Approval application has been submitted with Northwood Mortgage"
    @body["contact"]  = contact
  end
    
  def existing_pre_approval(contact)
    setup_email(contact)
    @subject          = "Your Pre-Approval application has been submitted with Northwood Mortgage"
    @body["contact"]  = contact
  end

  def rate_watch_signup(contact)
    setup_email(contact)
    @subject          = "You have subscribed to the Northwood Mortgage Rate Watch newsletter"
    @body["contact"]  = contact
  end

  def newsletter_issue(contact, newsletter_issue)
    setup_email(contact)
    @subject                  = newsletter_issue.subject
    @body[:newsletter_issue]  = newsletter_issue
    if contact.is_a?(Contact)
      @body[:agent]  = contact.user 
    else
      @body[:agent] = contact
    end
  end
end