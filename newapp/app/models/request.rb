class Request < ActiveRecord::Base
  belongs_to :job_candidate
  belongs_to :career_report
end
