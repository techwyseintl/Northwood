namespace :northwood do


  desc "Send scheduled newsletter issues to the subscribed contacts"
  task :send_newsletters => [:environment] do |t|

  # Command line arguments
  # ENV['DONT_SEND'] = true   => If present the emails will not actually be send
  # ENV['LIVE'] = true        => If NOT present the email addressed will be replaced with @workingdata.net
  # ENV['SEND_ONLY_AFTER'] = some_email@somewhere.com  => If present it will send emails to people on the subscription list after this email
    
    require 'net/smtp'
    require 'enumerator'
    require 'breakpoint'
    
    #number of mails sent in one connection to the smtp server
    SENDING_BATCH_SIZE=50
    
    #SMTP configuration
    SMTP_SERVER = ActionMailer::Base.smtp_settings[:address]
    SMTP_PORT = ActionMailer::Base.smtp_settings[:port]
    SMTP_DOMAIN = ActionMailer::Base.smtp_settings[:domain]
    
    puts "Server: #{SMTP_SERVER}:#{SMTP_PORT}"
    
    @newsletter_issues = NewsletterIssue.find(:all, :conditions => ["status = ?", SCHEDULED])
    puts "Found #{@newsletter_issues.size} scheduled newsletter issue(s)."
    
    @errors_occurred = false
    @email_log = []
    @email_log << "Server: #{SMTP_SERVER}:#{SMTP_PORT}"
    @email_log << "Found #{@newsletter_issues.size} scheduled newsletter issue(s)."
    
    if ENV.include?("LIVE") && ENV['LIVE'] == 'true'
      puts '== LIVE MODE =='
    else
      puts '== TEST MODE =='
    end
    
    @newsletter_issues.each do |newsletter_issue|
      
      # Build the recipient list
      recipients = []
      @email_log << ''
      @email_log << "Sending newsletter '#{newsletter_issue.newsletter.name} - #{newsletter_issue.subject}' to #{newsletter_issue.newsletter.subscribers.size} subscribers."
      puts "=> Sending newsletter '#{newsletter_issue.newsletter.name} - #{newsletter_issue.subject}' to #{newsletter_issue.newsletter.subscribers.size} subscribers."
      start_sending = !ENV.include?("SEND_ONLY_AFTER")
      newsletter_issue.newsletter.subscribers.each do |contact| 
        start_sending=true if contact.email == ENV['SEND_ONLY_AFTER']
        if start_sending
          # If we're in test mode, send all the emails to '@workingdata.net'
          contact.email = contact.email[/(.*)@/]+'workingdata.net' unless ENV.include?("LIVE") && ENV['LIVE'] == 'true'
          recipients << contact if !recipients.include?(contact)
        end  
      end

      exceptions = {}
      sent = 0
      recipients.each_slice(SENDING_BATCH_SIZE) do |recipients_slice|
        Net::SMTP.start(SMTP_SERVER, SMTP_PORT, SMTP_DOMAIN) do |sender|
          recipients_slice.each do |contact|
              print "Sending to #{contact.id} - #{contact.email} ..."
              tmail = ContactNotifier.create_newsletter_issue(contact, newsletter_issue)
              tmail.to = contact.email
            begin
              tmail.from = contact.user.email if contact.user
              sender.sendmail tmail.encoded, tmail.from, tmail.to unless ENV.include?("DONT_SEND") && ENV['DONT_SEND'] == 'true'
              puts "Ok"
              sent+=1
            rescue Exception => e
              exceptions[contact.email] = e 
              #needed as the next mail will send command MAIL FROM, which would 
              #raise a 503 error: "Sender already given"
              puts "FAILED"
              sender.finish
              sender.start
            end
          end
        end
      end
      newsletter_issue.update_attributes({:status=>SENT, :sent_at=>Time.now})
      puts "Sent #{sent} emails."
      @email_log << "Sent #{sent} emails."
      if exceptions.length > 0
        @errors_occurred = true
        logfile = "log/mailing-exceptions-#{Time.now.strftime("%Y-%m-%dT%H.%M.%S")}.yaml"
        File.open( logfile, 'w' ) do |out| YAML.dump( exceptions, out ) end
        puts "You can find a dump of the exceptions in #{logfile}"
        @email_log << "You can find a dump of the exceptions in #{logfile}"
      end
    end
    @email_log_subject = "Sent #{@newsletter_issues.size} scheduled newsletter"
    @email_log_subject += " <<Errors occurred>>" if @errors_occurred
    AdminNotifier::deliver_newsletters_sent_notification(@email_log_subject, @email_log.join('<br/>'))
  end
    
  desc "Removes duplicated subscriptions"
  task :remove_duplicated_subscriptions => [:environment] do |t|    
    puts "=> Checking for repeated subscriptions..."
    Newsletter.find(:all).each do |newsletter|
      newsletter.subscribers.each do |contact| 
        @subscriptions = contact.subscriptions.find(:all, :conditions=>['newsletter_id=1'])
        if @subscriptions.size > 1
          print "ID:#{contact.id} - #{contact.email} has -#{@subscriptions.size}- repeated subscriptions ..."
          contact.subscribes_to = {"1"=>"1", "2"=>"1"} 
          contact.save
          puts "FIXED"
        end  
      end
    end
  end    
end