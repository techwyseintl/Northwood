class RateWatchController < ApplicationController
  verify :method => :post,    :only => :create,   :redirect_to => { :action => :new }

  skip_before_filter  :login_required
  before_filter       :flag_public_area
  before_filter       :active_agent_required
  
  def new
    @contact = Contact.new
  end
  
  def create
    @contact = Contact.new(params[:contact])
    
    @subscribed_to_one = false
    params[:contact][:subscribes_to].each {|newsletter_id, subscribed| @subscribed_to_one=true if subscribed=='1'}
    if !@subscribed_to_one
      flash[:error] = 'Please select at least one newsletter.'
      render :action => 'new_rate_watch_signup'
      return
    end

    # If the contact already exists, just make sure it is subscribed and notify the admin
    if (@existing_contact = Contact.find_by_email(params[:contact]['email'])) && !params[:contact]['email'].empty?
      @existing_contact.subscribes_to = params[:contact][:subscribes_to]
      @existing_contact.delete_subscriptions
      @existing_contact.save_subscriptions
      ContactNotifier.deliver_rate_watch_signup(@existing_contact)
    else
      params[:contact][:subscribes_to] = {Newsletter.find_by_name('Rate Watch').id, '1'}
      @contact.user_id = @agent.id if @agent
      @contact.save!
      ContactNotifier.deliver_rate_watch_signup(@contact)
    end
    
    flash[:notice] = 'You have successfuly subscribed to the Rate Watch newsletter.'
    session[:show_tracking_scripts] = true
    redirect_to @agent ? "/#{@agent.webpage_address}" : '/'
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

end
