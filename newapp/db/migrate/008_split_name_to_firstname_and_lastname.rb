class SplitNameToFirstnameAndLastname < ActiveRecord::Migration
  def self.up
    #for table users
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    remove_column :users, :name
    
    #for table contacts    
    add_column :contacts, :first_name, :string
    add_column :contacts, :last_name, :string
    remove_column :contacts, :name
    
    #for job candidates
    add_column :job_candidates, :first_name, :string
    add_column :job_candidates, :last_name, :string
    remove_column :job_candidates, :name

  end

  def self.down
    #for table users
    remove_column :users, :first_name
    remove_column :users, :last_name
    add_column :users, :name, :string
    
    #for table contacts    
    remove_column :contacts, :first_name
    remove_column :contacts, :last_name
    add_column :contacts, :name, :string
    
    #for job candidates    
    remove_column :job_candidates, :first_name
    remove_column :job_candidates, :last_name
    add_column :job_candidates, :name, :string
  end
end