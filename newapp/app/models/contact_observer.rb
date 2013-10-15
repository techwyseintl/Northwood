class ContactObserver < ActiveRecord::Observer

  def after_create(contact)
  rescue  Net::SMTPFatalError
    # This exception is thrown if the email domain address is the same as the server
    # TODO - I think you're only getting this problem from development mode, I know
    # for a fact that it works fine on the server in staging mode.
    return false
  end
  
end