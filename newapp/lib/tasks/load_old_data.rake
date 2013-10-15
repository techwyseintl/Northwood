# 2008-06-12 - Sean: commented this out as it's not being used anymore and the require 'CSV' command was causing problems

# require 'pp'
# require 'CSV'
# 
# namespace :northwood do
# 
#   desc "Loads the old data from a CSV file into the database"
#     task :load_old_data => [:environment] do |t|
#       require "user.rb"
#       require "contact.rb"
#       require "subscription.rb"
#       
#        cleanup   
#        load_agents
#        load_contacts
#        load_rateWatch_subscriptions
#     end
#   
#   
#   def cleanup
#       ActiveRecord::Base.connection.execute("DELETE FROM users WHERE id >= 45896 AND id <= 76100")  
#       ActiveRecord::Base.connection.execute("DELETE FROM contacts")  
#   end
#   
#   def not_nil(value)
#     if value.nil?
#       ""
#     else
#       value
#     end
#   end
#   
#   def dash_string(string)
#     # Use only the first two strings to avoid having stuff like Ph.D. in the webpage_address
#     string_array = string.split(' ')
#     "#{string_array[0]}-#{string_array[1]}"
#   end
#   
#   # Loads the list of agents from the NothwoodAgentList.csv file
#   def load_agents
#       @filename = "#{RAILS_ROOT}/doc/NorthwoodAgentList.csv"
#       puts
#       puts "Opening CSV file: #{@filename}" 
#       print "Adding users: "  
#       idx = 0
#       CSV::Reader.parse(File.open(@filename, 'rb')) do |row|
#         # Skip the first row
#         if idx > 0
#           print "#{row[0]}, "
# 
#           @user = User.new(
#             :first_name   => not_nil(row[1]), 
#             :last_name    => not_nil(row[2]), 
#             :address      => "#{row[3]}\n#{row[4]}\n#{row[5]} #{row[6]}", 
#             :email        => not_nil(row[15]), 
#             :phone        => not_nil(row[7]), 
#             :fax          => not_nil(row[9]), 
#             :mobile       => not_nil(row[11]),
#             :started_on   => Time.now,
#             :job_title    => '',
#             :is_active    => 1,
#             :role         => 0,
#             :webpage_address => dash_string("#{row[1]} #{row[2]}").downcase
#           )
#           @user.password = @user.password_confirmation = @user.generate_password
# 
#           begin
#             @user.save!
#           rescue ActiveRecord::RecordInvalid
#             print 'rescue'
#             if(@user.errors[:email])
#               @user.email = "#{row[0]}@northwoodmortgage.com"
#               print "renaming email to #{@user.email}"
#             end
#             if(@user.errors[:webpage_address])
#               @user.webpage_address = dash_string("#{row[1]} #{row[2]}-#{row[0]}").downcase
#               print "renaming webpage_address to #{@user.webpage_address}"
#             end
#             retry
#           end
#           ActiveRecord::Base.connection.execute("UPDATE users SET id = #{row[0]} WHERE id = #{@user.id}")
#         end
#         idx+=1
#       end
#       puts
#       puts "==> Done! #{idx} users added to the database"   
#   end
#   
#   
#   # Loads the list of contacts from the NorthwoodPersonalContacts.csv file
#   def load_contacts
#     @filename = "#{RAILS_ROOT}/doc/NorthwoodPersonalContacts.csv"
#     puts
#     puts "Opening CSV file: #{@filename}"   
#     puts "Adding contacts: "  
#     idx = 0
#     CSV::Reader.parse(File.open(@filename, 'rb')) do |row|
#       # Skip the first row
#       add_contact(row) if idx > 0
#       idx+=1
#     end
#     puts "==> Done! #{idx} contacts added to the database"
#   end 
#   
#   
#   # Loads the list of contacts from the NorthwoodRateWatch.csv file
#   def load_rateWatch_subscriptions
#     @filename = "#{RAILS_ROOT}/doc/NorthwoodRateWatch.csv"
#     puts
#     puts "Opening CSV file: #{@filename}"   
#     puts "Adding subscriptions "  
#     idx = 0
#     CSV::Reader.parse(File.open(@filename, 'rb')) do |row|
#       # Skip the first row
#       if idx > 0
# 
#         row[0]='unknown' if !row[0]
#         row[1]=row[0] if row[1].strip.empty?
#         
#         # Check if the contact already exits
#         
#         if contact = Contact.find_by_email(row[2])
#           print "#{row[2].downcase} ... "
#           # Check if the info matches
#           if(contact.email == row[2].downcase && contact.first_name == row[0].capitalize && contact.last_name == row[1].capitalize &&  contact.user_id == row[3].to_i)
#             puts " already exists. [MATCHES]"
#           else
#             print " already exists. [DIFF] replacing ..."
#             contact.first_name = row[0].capitalize
#             contact.last_name = row[1].capitalize
#             contact.email = row[2].downcase
#             contact.user_id= row[3]
#             contact.address  = ''
#             contact.phone    = ''
#             contact.fax      = ''
#             contact.notes    = ''
#             contact.mobile   = ''
#             begin
#               contact.save!
#             rescue ActiveRecord::RecordInvalid
#               puts "Failure on contact: #{row[0]} #{row[1]} #{row[2]} #{row[3]}"
#             end
#             puts 'Ok'
#           end
#         else
#           # The contact doesn't exist yet, so create a new one
#           contact = add_contact(row)
#         end
# 
#         # Add the subscription
#         subscription = Subscription.new(:contact_id => contact.id, :newsletter_id => 1 )   
#         subscription.save!
#       end
#       idx+=1
#     end
#     puts "==> Done! #{idx} subscriptions added to the database"
#   end   
#   
#   
#   def add_contact(row)
#       print "#{row[2].downcase} ... "
#       row[1]=row[0] if row[1].strip.empty?
#       
#       # Make sure that the agent this contact is related to actually exists
#       begin
#         User.find(row[3])
#         contact = Contact.new(:first_name=>row[0].capitalize, 
#                               :last_name=>row[1].capitalize, 
#                               :email => row[2].downcase, 
#                               :user_id=> row[3],
#                               :address => '',
#                               :phone    => '',
#                               :fax      => '',
#                               :notes    => '',
#                               :mobile   => '');
#       rescue ActiveRecord::RecordNotFound 
#         print "agent #{row[3]} not found. Adding as unassigned contact..."
#         contact = Contact.new(:first_name=>row[0].capitalize, 
#                               :last_name=>row[1].capitalize, 
#                               :email => row[2].downcase,
#                               :address => '',
#                               :phone    => '',
#                               :fax      => '',
#                               :notes    => '',
#                               :mobile   => '');
#       end
#       begin
#         contact.save!
#       rescue ActiveRecord::RecordInvalid
#         puts "Failure on contact: #{row[0]} #{row[1]} #{row[2]} #{row[3]}"
#       end
#       puts "Ok"
#       contact
#   end
# end
