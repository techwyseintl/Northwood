class AddingPhoneToJobCandidates < ActiveRecord::Migration
  def self.up
    add_column :job_candidates, :phone, :string
  end

  def self.down
    remove_column :job_candidates, :phone
  end
end
