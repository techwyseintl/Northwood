# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  
  skip_before_filter  :login_required,    :only => [:new, :create]
  before_filter       :flag_public_area,  :only => :new
  
  def new; end

  def create
    self.current_user = User.authenticate(params[:email], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      flash[:notice] = "Logged in successfully"

      if is_admin?
        redirect_to users_path()
      else
        redirect_to user_path(current_user)
      end
    else
      flash[:error] = "Incorrect username or password."
      redirect_to login_url
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to '/'
  end
end
