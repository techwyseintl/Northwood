class PoliciesProceduresFilesController < ApplicationController
  verify :method => :post,    :only => :create, :redirect_to => { :action => :index }
  verify :method => :put,     :only => :update,   :redirect_to => { :action => :index }
  verify :method => :delete,  :only => :destroy,  :redirect_to => { :action => :index }

  skip_before_filter  :login_required,  :only => [:index, :show]
  
  FOLDER = 'policies_and_procedures'
  
  
  def index
    if !@current_user
      redirect_to login_path 
      return
    end
    @shared_files = SharedFile.all_from_folder(FOLDER)
  end
  
  def create
    @shared_file = SharedFile.new(params[:shared_file].merge(:folder => FOLDER))
    if @shared_file.save
      flash[:notice] = 'The file was successfully created.'
      redirect_to policies_procedures_files_path
    else
      @shared_files = SharedFile.all_from_folder(FOLDER)
      render :action => :index
    end
  end
  
  def destroy
    @shared_file = SharedFile.find(params[:id]).destroy
    flash[:notice] = "The file <b>'#{@shared_file.filename}'</b> was deleted."
    redirect_to policies_procedures_files_path
  end
  
  # This will return the requested file to the agent
  def show
    if !@current_user
      redirect_to login_path 
      return
    end
    @shared_file = SharedFile.find(params[:id])
    send_file(@shared_file.public_filename, :filename => @shared_file.filename, :type => @shared_file.content_type)
  end
  
protected
       
  def authorized?
    is_admin? 
  end
    
end
