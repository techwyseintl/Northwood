class AddNotificationSentToJobCandidates < ActiveRecord::Migration
  def self.up
    add_column :job_candidates, :notification_sent, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column "job_candidates", "notification_sent"
  end
end
