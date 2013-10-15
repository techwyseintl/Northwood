namespace :northwood_operations do

  # Usage:
  #   Testing:
  #     rake northwood_operations:send_contact_reminders
  #   
  #   Actualy sending the emails:
  #    rake northwood_operations:send_contact_reminders LIVE=true
  
  desc "Sending contact reminders"
	task :send_contact_reminders  => [:environment] do |t|
    
    puts "Sending contact notifications to:"
    users = User.find(:all)
    users.each do |user|
      user.contacts.each do |contact|
        contact.reminders.each do |reminder|
          if reminder.remind_on.send(:to_date) == Date.today
            if ENV.include?("LIVE") && ENV['LIVE'] == 'true'
              begin
                puts user.full_name
                eval "UserNotifier::deliver_contact_reminder(user, reminder)"
              rescue
                puts "Error: Failed sending email"
              end
            else
              puts "Test: Sending reminder to " + user.full_name
            end
          end
        end
      end
    end
  end    
 
 
  desc "Send the job candidate follow up emails 24 hours after they first got them"
  task :send_job_candidate_follow_up_emails => [:environment] do |t|
    @candidates = JobCandidate.find(:all, :conditions => ["created_at < ? AND notification_sent = 0 ", Time.now.at_beginning_of_day])
    sent = 0
    @candidates.each do |candidate|
      candidate.update_attribute('notification_sent', 1)
      begin
        JobCandidateNotifier::deliver_followup_sent(candidate)
        puts "Emailing followup to #{candidate.email}"
        sent+=1
      rescue
        puts "Failed on #{candidate.email}"
      end
    end
    puts "Sent #{sent} followup emails."
  end
    
end