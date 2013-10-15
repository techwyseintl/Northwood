class Subscription < ActiveRecord::Base
  belongs_to :newsletter
  belongs_to :contact
end
