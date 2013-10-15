namespace :northwood do
  
  desc "Send shared files notification to all the agents"
  task :send_shared_files_notification => [:environment] do |t|
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

    #Build the recipient list
    recipients = []
    @agents = User.find(:all, :conditions => "is_active = 1 AND (role=0 OR role=1)")
    puts "Sending notification to #{@agents.size} agents."
    @agents.each do |agent|  
      # If we're in test mode, send all the emails to '@workingdata.net'
      agent.email = agent.email[/(.*)@/]+'twg.ca' unless ENV.include?("LIVE") && ENV['LIVE'] == 'true'
      recipients << agent
    end
    
    # Grab the list of shared files
    @shared_files = SharedFile.find(:all, :conditions => {:folder => 'main'}, :order => "created_at DESC")

    puts "sending...."
    
    exceptions = {}
    sent = 0
    recipients.each_slice(SENDING_BATCH_SIZE) do |recipients_slice|
      Net::SMTP.start(SMTP_SERVER, SMTP_PORT, SMTP_DOMAIN) do |sender|
        recipients_slice.each do |agent|
          tmail = UserNotifier.create_shared_files_notification(agent, @shared_files)
          tmail.to = agent.email
          tmail.from = SHARED_FILES_NOTIFICATION_FROM_EMAIL
          begin
            sender.sendmail tmail.encoded, tmail.from, tmail.to
            sent+=1
          rescue Exception => e
            exceptions[agent.email] = e 
            #needed as the next mail will send command MAIL FROM, which would 
            #raise a 503 error: "Sender already given"
            sender.finish
            sender.start
          end
        end
      end
      puts "Sent #{sent} emails."
      
      if exceptions.length>0
        logfile = "log/mailing-exceptions-#{Time.now.strftime("%Y-%m-%dT%H:%M:%S")}.yaml"
        File.open( logfile, 'w' ) do |out| YAML.dump( exceptions, out ) end
        puts "You can find a dump of the exceptions in #{logfile}"
      end
    end
  end
    
end