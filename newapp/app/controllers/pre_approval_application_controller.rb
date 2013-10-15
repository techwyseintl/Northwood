class PreApprovalApplicationController < ApplicationController
  verify :method => :post,    :only => :create,   :redirect_to => { :action => :new }

  skip_before_filter  :login_required
  before_filter       :flag_public_area
  before_filter       :active_agent_required

  def new
    @contact = Contact.new
  end

  def create

    if params[:contact].empty? || params[:contact][:email].empty?
      flash[:error] = "You must enter an email address"
      @contact = Contact.new
      render :action => 'new'
      return
    end
    
    # If the contact already exists, just update the notes and notify the admin, the agent (if exists) and the contact
    if (@contact = Contact.find_by_email(params[:contact]['email']))
      @contact.update_attributes_if_not_empty(params[:contact])
      @contact.update_attribute(:user_id, @agent.id) if @agent
      ContactNotifier.deliver_existing_pre_approval(@contact)    
      flash[:notice] = "Your pre-approval application was submitted, you will be contacted within 1 business day.<br/>Looks like we already have some of your information in our system. We've sent your stored info to your email. If you need to update your information, please contact the Admin/Agent" 
    else
      @contact = Contact.new(params[:contact])
      @contact.user = @agent if @agent
      @contact.save!
      ContactNotifier.deliver_pre_approval(@contact)
      flash[:notice] = "Your Pre-Approval Application was submitted, you will be contacted within 1 business day."
    end
    
    if @contact.user
      AdminNotifier::deliver_pre_approval(@contact.user, @contact)
    else
      User.notified_admins.each do |admin|
        AdminNotifier::deliver_pre_approval(admin, @contact)
      end
    end

    session[:show_tracking_scripts] = true    
    redirect_to @agent ? "/#{@agent.webpage_address}" : '/'
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

end
