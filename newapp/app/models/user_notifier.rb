class UserNotifier < ActionMailer::Base
  
  include MailerSupport
  
  include ActionController::UrlWriter
  default_url_options[:host] = SITE_URL
  
  def forgot_password(user, new_password)
    setup_email(user)
    @subject              += "New password for #{user.full_name}"
    @body[:new_password]   = new_password
  end
  
  def contact_reminder(user, reminder)
    setup_email(user)
    @subject            += "Reminder Re: " + reminder.contact.full_name
    @body[:contact]      = reminder.contact.full_name
    @body[:reminder]     = reminder.message
  end
  
  def user_created(user, password)
    setup_email(user)
    @subject    += "Your account is created"
    @body[:password] = password
  end
  
  def shared_files_notification(user, shared_files)
    setup_email(user)
    @subject    += "New files have been uploaded"
    @body[:shared_files] = shared_files
  end

  def test_email(to, from)
    @recipients  = to
    @from        = from
    @subject     = "[TEST] This is a test email"
    @sent_on     = Time.now
  end
end