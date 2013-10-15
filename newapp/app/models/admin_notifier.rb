class AdminNotifier < ActionMailer::Base
  
  include MailerSupport
  helper ApplicationHelper
  
  include ActionController::UrlWriter
  default_url_options[:host] = SITE_URL
  
  def contact_request(admin, contact)
    setup_email(admin)
    @subject        += "Contact Request"
    @body[:contact]  = contact
  end
  
  def mortgage_renew_request(admin, contact_params)
    setup_email(admin)
    @subject        += "Mortage Renewal Contact Request"
    
    @body[:name]            = contact_params[:name]
    @body[:email]           = contact_params[:email]
    @body[:maturity_date]   = contact_params[:maturity_date]
  end

  def mortgage_life_contact_request(mortgage_life_admin, contact)   
    setup_email(mortgage_life_admin)
    @subject        += "Contact Request from Northwood Mortgage Life"
    @body[:contact]  = contact
  end
    
  def referral_contact_request(referral_admin, contact, referral)   
    setup_email(referral_admin)
    @subject        += "Contact Request from a referral: #{referral.name}"
    @body[:contact]  = contact
    @body[:referral]  = referral
  end
  
  def new_contact(admin, contact)
    setup_email(admin)
    @subject        += "New Contact"
    @body[:contact]  = contact
  end

  def pre_approval(admin, contact)
    setup_email(admin)
    @subject        += "New Pre-Approval Application"
    @body[:contact]  = contact
  end  

  def career_applicant(admin, career_applicant)
    setup_email(admin)
    @subject        += "New Career Applicant"
    @body[:career_applicant]  = career_applicant
  end  
  
  def newsletters_sent_notification(subject, text)
    @recipients  = "info@theworkinggroup.ca"
    @from        = SYSTEM_EMAIL
    @subject     = "[NORTHWOOD] #{subject}"
    @sent_on     = Time.now
    @body[:text] = text
  end
end