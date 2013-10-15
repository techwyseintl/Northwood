class UsersController < ApplicationController
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post,    :only => :create,   :redirect_to => { :action => :index }
  verify :method => :put,     :only => :update,   :redirect_to => { :action => :index }
  verify :method => :delete,  :only => :destroy,  :redirect_to => { :action => :index }
  
  skip_before_filter  :login_required,  :only => :forgot_password
  before_filter       :load_user,       :except => [:index, :new, :create, :forgot_password]
  
  
  def index
    conditions = user_search_parameters('users')
    conditions = conditions ? "(" + conditions + ") AND users.is_active = 1" : "users.is_active = 1" unless is_admin?
    
    @user_pages, @users = paginate  :users, 
                                    :per_page => 10, 
                                    :order => "CONCAT(first_name, ' ', last_name)",
                                    :conditions => conditions                                    
  end
  
  def show; end
  
  def new
    @user = User.new
  end
  
  def edit; end

  def create
    @user = User.new(params[:user])
    @user.save!
    redirect_to user_path(@user)
    flash[:notice] = "A new agent has been created!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end
  
  def update
    # only admin can alter these fields
    if (params[:user]['started_on'] or params[:user]['webpage_address'] or params[:user]['role'] or params[:user]['is_active'] or params[:user]['address'] or params[:user]['started_on']) and !@current_user.is_admin?
      flash[:error] = "You are not allowed to edit this information"
      redirect_to edit_user_path(@user) and return
    end
    
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to user_path(@user)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user.destroy
    flash[:notice] = "#{@user.full_name} was successfully deleted."
    redirect_to users_path
  end
  
  def forgot_password
    if request.post?
      if @user = User.find_by_email(params[:user][:email]) and new_password = @user.save_new_password
        UserNotifier::deliver_forgot_password(@user, new_password)
        flash[:notice] = 'A new password has been generated for you and emailed to the address you entered.'
        redirect_to login_path
      else
        @user = User.new
        @user.errors.add("email", "Cannot find that email address, did you mistype?")
      end
    end
  end
  
  # sending welcome email to agent
  def welcome
    # only admin can send emails like these
    if !@current_user.is_admin?
      respond_with_403 and return
    end
    
    
    if @user.is_active == 0
      flash[:error] = "Please Activate this Agent before sending welcome email."
    else
      UserNotifier::deliver_user_created(@user, @user.save_new_password)
      flash[:notice] = 'Welcome email has been sent.'
    end
    
    
    redirect_to user_path
  end
  

protected

  def load_user
    @user = User.find params[:id]
  end
     
  def authorized?
    is_admin? || params[:id] == current_user.id.to_s
  end
end
