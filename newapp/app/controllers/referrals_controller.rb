class ReferralsController < ApplicationController
  #before_filter       :flag_public_area
  skip_before_filter  :login_required, :only => [:webpage, :contact]
  before_filter       :load_referral, :only => [:edit, :update, :destroy, :contact]
  
  def index
    @referrals = Referral.find(:all, :order => 'name')
  end
  
  def new
    @referral = Referral.new
  end

  def create
    @referral = Referral.create!(params[:referral])
    redirect_to referrals_path
    flash[:notice] = 'The Referral Page was successfully created.'
  rescue  ActiveRecord::RecordInvalid => e
    @referral = e.record
    render :action => 'new'
  end
  
  def edit
    # ...
  end

  def update
    if @referral.update_attributes(params[:referral])
      redirect_to referrals_path
      flash[:notice] = 'The Referral Page was successfully updated.'
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @referral.destroy
    flash[:notice] = "The referral #{@referral.name} was successfully deleted."
    redirect_to referrals_path
  end
  
  def webpage
    if @referral = Referral.find_by_webpage_address(params[:path][0])
      @referral_area = true
      @page_title = @referral.name + ' - Northwood Mortgage '
      render :action => 'webpage'
    else
      respond_with_404
    end
  end
  
  def contact
    @contact = Contact.new(params[:contact])
    if !@contact.email[/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i]
      @contact.errors.add(:email, "You have entered an invalid email address.")
    end
    if @contact.first_name.empty? or @contact.last_name.empty? or @contact.phone.empty? or @contact.notes.empty? or !@contact.email[/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i]
      @contact.errors.add_to_base("Please make sure you fill out all the fields.")
      @referral_area = true
      render :action=>'webpage'
    else
      AdminNotifier::deliver_referral_contact_request(User.new(REFERRAL_ADMIN), @contact, @referral)
      flash[:notice] = 'Thank you. You will be contacted shortly.'
      redirect_to '/'
    end
  end
  
private
  def authorized?
    is_admin? || params[:action] == 'webpage' || params[:action] == 'contact'
  end

  def load_referral
    @referral = Referral.find(params[:id])    
  end

  def full_path(file)
    "#{RAILS_ROOT}/app/views/content/#{file}.haml"
  end
end
