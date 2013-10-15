class CareerReport < ActiveRecord::Base
  has_many :requests
  has_many :job_candidates, :through => :requests
  
  has_attachment :storage => :file_system, 
                 :max_size => 8.megabytes
                 
  validates_as_attachment
end
