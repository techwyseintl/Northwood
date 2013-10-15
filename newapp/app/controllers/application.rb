class ApplicationController < ActionController::Base
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  include ExceptionNotifiable
  
  before_filter :check_reversemortgageplan_redirect
  before_filter :login_from_cookie
  before_filter :login_required
  before_filter :load_logged_in_user # still need @current_user even if not forcing to log in

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_northwood_session_id'
  
  
  def respond_with_404
    render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404
  end
  
  def respond_with_403
    render :file => "#{RAILS_ROOT}/public/403.html", :layout => false, :status => 403
  end
  
  def is_admin?
    (!@current_user.nil?) ? @current_user.is_admin? : false
  end

  def is_agent?
    !@current_user.is_admin?
  end
  

  def load_logged_in_user
    #Added the next line because if the login_required is skipped, the value of @current_user is not passed
    @current_user = nil
    if session[:user]
      @current_user = User.find_by_id(session[:user]) || nil
    end 
  end
  
  def user_search_parameters(model)
    conditions = nil
    if params[:search_string] and params[:search_string].match(/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i).to_s == params[:search_string]
      conditions = User.send(:sanitize_sql, ["#{model}.email LIKE ?", "%#{params[:search_string]}%"])
    elsif params[:search_string]
      condition = []
      params[:search_string].split(' ').each do |token|
        condition << User.send(:sanitize_sql, ["#{model}.first_name LIKE ?", "#{token}%"])
        condition << User.send(:sanitize_sql, ["#{model}.last_name  LIKE ?", "#{token}%"])
      end
      conditions = condition.join(' OR ')
    end
    
    # Never show the admins that are not agents
    if model == 'users'
      conditions = (conditions.nil? || (conditions && conditions.empty?)) ? '' : "(#{conditions}) AND "
      conditions += "role != #{ADMIN_ONLY.to_s}"
    end
    
    return conditions
  end


  def request_from_reversemortgageplan?
    request.host == 'reversemortgageplan.ca' || request.host == 'www.reversemortgageplan.ca'
  end
  helper_method :request_from_reversemortgageplan?

protected
  
  def load_user
    @user = User.find params[:user_id]
  end

  def load_contact
    @contact = @user.contacts.find params[:contact_id]
  end

  # we set this variable to control layout display
  def flag_public_area
    if params[:webpage_address]
      @agent_area = true 
    else
      @public_area = true
    end       
  end
  
  def active_agent_required 
    @user = @agent = User.find_by_webpage_address(params[:webpage_address])
    respond_with_404 if (@agent_area && @agent.nil?) || (@agent && !@agent.is_active?)
  end

  def check_reversemortgageplan_redirect
    if request_from_reversemortgageplan? 
      if params[:controller] != 'content' || !%w{load_content create_reverse_mortgages_contact_request}.include?(params[:action])
        redirect_to SITE_URL + request.env['REQUEST_URI']
      end
    end
  end
  
end


