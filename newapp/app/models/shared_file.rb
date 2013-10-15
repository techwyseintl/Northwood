class SharedFile < ActiveRecord::Base
  has_attachment :storage => :file_system, 
                 :max_size => 8.megabytes,
                 :path_prefix => 'shared_files'
                 
  validates_as_attachment
  
  def self.all_from_folder(folder)
    SharedFile.find(:all, :conditions => {:folder => folder})
  end
  
  def short_filename
    if self.filename.size<=30
      filename
    else
      self.filename[0..30]+'...' 
    end
    
  end
end
