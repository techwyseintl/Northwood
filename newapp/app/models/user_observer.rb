class UserObserver < ActiveRecord::Observer

  def before_save(user)
    user.webpage_html = RedCloth.new(user.webpage_text.to_s).to_html
  end

  def after_destroy(user)
    user.contacts.each do |contact| 
      contact.reminders.each {|reminder| reminder.destroy}
      contact.update_attribute(:user_id, nil)
    end
  end
end