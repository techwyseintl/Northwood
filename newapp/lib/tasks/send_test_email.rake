namespace :northwood do

  desc "Send test email"
  task :send_test_email => [:environment] do |t|
    require 'net/smtp'
    require 'enumerator'
    require 'breakpoint'

    #SMTP configuration
    SMTP_SERVER = ActionMailer::Base.smtp_settings[:address]
    SMTP_PORT = ActionMailer::Base.smtp_settings[:port]
    SMTP_DOMAIN = ActionMailer::Base.smtp_settings[:domain]

    puts "Server: #{SMTP_SERVER}:#{SMTP_PORT}"
    recipients = [
      'hesham@theworkinggroup.ca',
      'dominic@theworkinggroup.ca'
    ]
    puts 'Sending #{recipients.size} emails...'
    sent = 0
    recipients.each do |recipient|
      Net::SMTP.start(SMTP_SERVER, SMTP_PORT, SMTP_DOMAIN) do |smtp|
        tmail = UserNotifier.create_test_email(recipient, 'admin@northwoodmortgage.com') 
        begin
          smtp.sendmail tmail.encoded, tmail.from, tmail.to
          puts "Sent email to #{tmail.to}"
          sent+=1
        rescue Exception => e
          puts "Failed sending email to #{tmail.to}."
        end
      end
    end
    puts "Sent #{sent} emails."
  end
end

