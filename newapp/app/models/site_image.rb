class SiteImage < ActiveRecord::Base
  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :max_size => 8.megabytes,
                 :resize_to => '300x600>',
                 :thumbnails => { :thumb => '150x300>' }

  validates_as_attachment
end
