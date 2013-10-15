class NewslettersController < ApplicationController  
  verify :method => :post,    :only => :create,   :redirect_to => { :action => :index }
  verify :method => :put,     :only => :update,   :redirect_to => { :action => :index }
  verify :method => :delete,  :only => :destroy,  :redirect_to => { :action => :index }
  
  before_filter :login_required, :except => [:confirm_unsubscribe, :unsubscribe]
  before_filter :flag_public_area,  :only => [:confirm_unsubscribe, :unsubscribe]
  def index
    @newsletters = Newsletter.find(:all)
  end

  def new
    @newsletter = Newsletter.new
  end

  def create
    @newsletter = Newsletter.new(params[:newsletter])
    @newsletter.save!
    flash[:notice] = 'The newsletter was successfully created.'
    redirect_to newsletters_path
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

  def edit
    @newsletter = Newsletter.find(params[:id])
    can_be_edited(@newsletter)
  end

  def update
    @newsletter = Newsletter.find(params[:id])   
    can_be_edited(@newsletter)
    if @newsletter.update_attributes(params[:newsletter])          
      flash[:notice] = 'The newsletter was successfully updated.'
      redirect_to newsletters_path and return
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @newsletter = Newsletter.find(params[:id])   
    can_be_edited(@newsletter)
    @newsletter.destroy
    flash[:notice] = 'The newsletter was deleted as well as all the issues and subscriptions.'
    redirect_to newsletters_path
  end 

  def confirm_unsubscribe
    # Check if the newsletter exists
    begin
      @newsletter = Newsletter.find(params[:id]) 
    rescue
      flash[:notice] = "The newsletter you're trying to unsubscribe from doesn't exist."
      redirect_to '/' 
      return
    end

    render :template => 'content/unsubscribe_newsletter'
  end
  
  def unsubscribe
    # Check if the newsletter exists
    begin
      @newsletter = Newsletter.find(params[:id]) 
    rescue
      flash[:notice] = "The newsletter you're trying to unsubscribe from doesn't exist."
      redirect_to '/' 
      return
    end
    # Check if there is a contact with the given email
    begin    
      @contact = Contact.find_by_email(params[:email][0])
      @user_subscription = @newsletter.subscriptions.find_by_contact_id(@contact.id)
      @user_subscription.destroy
      @contact.notes << "\n-------------\nUnsubscribed from #{@newsletter.name} on #{Time.now.to_s :default}"
      @contact.save!
    rescue
      flash[:notice] = "The email #{params[:email]} is not subscribed for this newsletter. "
      redirect_to unsubscribe_newsletter_path(@newsletter, params[:email][0])
      return
    end

    flash[:notice] = "#{params[:email]} has been unsubscribed from the #{@newsletter.name} newsletter. Thank you."
    redirect_to '/'
  end 
protected
     
  def authorized?
    is_admin?
  end
   
  def can_be_edited(newsletter)
    if !@newsletter.can_be_edited? 
      flash[:notice] = 'The Rate Watch newsletter cannot be edited nor deleted.'
      redirect_to newsletters_path and return
    end
  end
end  