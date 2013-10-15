class Reminder < ActiveRecord::Base
  belongs_to :contact
  validates_presence_of :message
end
