class SiteImagesController < ApplicationController
  verify :method => :post,    :only => :create, :redirect_to => { :action => :index }
  verify :method => :put,     :only => :update,   :redirect_to => { :action => :index }
  verify :method => :delete,  :only => :destroy,  :redirect_to => { :action => :index }

  before_filter :login_required
  
  def index
    @images = SiteImage.find(:all, :conditions=>'parent_id IS NULL', :order => "id DESC")
  end
  
  def create
    @image = SiteImage.new(params[:image])
    if @image.save
      flash[:notice] = 'The image was successfully uploaded.'
      redirect_to site_images_path
    else
      @images = SiteImage.find(:all, :conditions=>'parent_id IS NULL', :order => "id DESC")
      render :action => :index
    end
  end
  
  def destroy
    SiteImage.find(params[:id]).destroy
    flash[:notice] = 'The image was deleted from the system.'
    redirect_to site_images_path
  end
  
protected
       
  def authorized?
    is_admin?
  end
     
end
