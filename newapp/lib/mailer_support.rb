module  MailerSupport
  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = SYSTEM_EMAIL
    @subject     = "[NORTHWOOD] "
    @sent_on     = Time.now
    @body[:user] = user
  end
end