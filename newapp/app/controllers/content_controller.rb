class ContentController < ApplicationController

  verify :method => :post, :only => [
    :create_contact_request, 
    :create_mortgage_life_contact_request, 
    :create_reverse_mortgages_contact_request ], :redirect_to => '/'
  
  # No need for login on the public pages
  before_filter       :flag_public_area
  skip_before_filter  :login_required
  
  def load_content
  
    if request_from_reversemortgageplan?
      # If a page comes from reversemortgageplan.ca then only allow the index, ownership, costs and contact
      if params[:path].empty?
        params[:path] = ['reverse-mortgages'] 
      else
        if params[:path].include?('ownership') || params[:path].include?('costs')
          params[:path] = ['reverse-mortgages'] + params[:path]
        elsif !params[:path].include?('contact')
          # Redirect to northwoddmortgage.com
          return redirect_to(SITE_URL + '/' + params[:path].join('/'))
        end
      end
    end
  
    # check if agent site exists at this address
    if user = User.find_by_webpage_address(params[:path][0], :conditions => 'is_active = 1')
      agent_webpage(user)
      return
    end
    file = params[:path].empty?  ?  'index'  :  params[:path].join('/');
    
    # See if file exists at this path  
    if File.exists? full_path(file)
      render :file => full_path(file), :layout => 'application'
    # Else assume it's a directory then, and look for /index
    elsif File.exists? full_path(file + '/index')
      render :file => full_path(file + '/index'), :layout => 'application'
    else
      respond_with_404
    end
  end
  
  def agent_webpage(user)
    
    @agent_area = true
    @user = user
    @page_title = @user.full_name + ' - Northwood Mortgage ' + @user.job_title

    case params[:path][1].to_s
    when 'payment-calculator'
      @page_header = "Payment Calculator"
      render :partial => 'content/calculators/payment_calculator', :layout => 'application' and return
    when 'land-transfer-tax'
      @page_header = "Ontario Land Transfer Tax Calculator"
      render :partial => 'content/calculators/land_transfer_tax', :layout => 'application' and return
    when 'mortgage-qualifier'
      @page_header = "Mortgage Qualifier"
      render :partial => 'content/calculators/mortgage_qualifier', :layout => 'application' and return
    when 'mortgage-information'
      params[:path][2] = 'index' if !params[:path][2]
      file = full_path([params[:path][1], params[:path][2]].join('/'))
      if File.exists? file
        render :file => file, :layout => 'application' and return
      else
        respond_with_404 and return
      end
    end
    render :action => 'agent_webpage'
  end
  
  # Contact request form used on the front page
  def create_contact_request
    
    # should never happen... but let's make sure
    redirect_to '/' and return if !params[:contact]
    
    # sending contents of the contact for to a specific agent instead of notified admins
    # removing user_id params in case it's wrong or something
    agent = User.find(params[:contact].delete('user_id')) rescue nil if params[:contact]['user_id']
    
    
    if params[:contact]['email'] && !params[:contact]['email'].empty? && (@existing_contact = Contact.find_by_email(params[:contact]['email']))
      # maybe some important message in notes?
      @existing_contact.append_to_notes("Submitted from Contact Us form:\n#{params[:contact]['notes']}")
      @existing_contact.save!
      if agent
        # assigning this contact
        @existing_contact.update_attribute(:user_id, agent.id)
        AdminNotifier::deliver_contact_request(agent, @existing_contact)
      else
        User.notified_admins.each do |admin|
          AdminNotifier::deliver_contact_request(admin, @existing_contact)
        end
      end
    else
      @contact = Contact.new(params[:contact])
      @contact.notes = ''
      @contact.append_to_notes "Submitted from Contact Us form:\n#{params[:contact][:notes]}"
      
      # this can fail at the moment, let's just make sure we don't try to send email
      @contact.user_id = agent.id if agent
      @contact.save
      if @contact.valid?
        if agent
          AdminNotifier::deliver_contact_request(agent, @contact)
        else
          User.notified_admins.each do |admin|
            AdminNotifier::deliver_contact_request(admin, @contact)
          end
        end
      end
    end

    if (@contact && (@contact.phone.empty? || @contact.notes.empty? || !@contact.valid?)) || (@existing_contact && params[:contact]['notes'].empty?)
      flash[:error] = 'Please make sure all fields are properly filled out'
      if agent
        redirect_to '/' + agent.webpage_address
      elsif params[:contact_page]
        redirect_to '/contact'
      else  
        redirect_to '/'
      end  
          
    else
      flash[:notice] = "Thank you. You will be contacted shortly"
      session[:show_tracking_scripts] = true
      if agent
        redirect_to '/' + agent.webpage_address
      elsif params[:contact_page]
        redirect_to '/contact'
      else  
        redirect_to '/'
      end  
      
    end
  end

  # Contact request form used on the Northwood Mortgage Life page
  def create_mortgage_life_contact_request
    @contact = Contact.new(params[:contact])

    render :update do |page|
      if @contact.first_name.empty? or @contact.last_name.empty? or @contact.phone.empty? or @contact.notes.empty? or !@contact.email[/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i]
        page.replace_html 'contact_form_error', 'Please make sure all fields are properly filled out'
        page.visual_effect :BlindDown, "contact_form_error", :duration => 0.2
        page.show 'contact_form_submit_button'
      else
        AdminNotifier::deliver_contact_request(User.new(NORTHWOOD_MORTGAGE_LIFE_ADMIN), @contact)
        page.hide 'contact_form_error'
        page.replace_html 'contact_form_message', 'Thank you. You will be contacted shortly.'
        page.visual_effect :BlindDown, "contact_form_message", :duration => 0.2
        page.visual_effect :BlindUp, "contact_form_content", :duration => 0.2
      end
    end
  end

  # Contact request form used on the Reverse Mortgages page
  def create_reverse_mortgages_contact_request
    @contact = Contact.find_by_email(params[:contact]['email'])
    if @contact.nil?
      @contact = Contact.new(params[:contact])
      @contact.notes = ''
    end
    @contact.append_to_notes "Submitted from Reverse Mortgages form:\n#{params[:contact][:notes]}"
    @contact.save!
    User.notified_admins.each do |admin|
      AdminNotifier::deliver_contact_request(admin, @contact)
    end
    render :update do |page|
      page.hide 'contact_form_error'
      page.replace_html 'contact_form_message', :partial => 'contacts/reverse_mortgage_thank_you'
      page.visual_effect :BlindDown, "contact_form_message", :duration => 0.2
      page.visual_effect :BlindUp, "contact_form_content", :duration => 0.2
    end
  rescue ActiveRecord::RecordInvalid
    render :update do |page|
      page.replace_html 'contact_form_error', 'Please make sure all fields are properly filled out'
      page.visual_effect :BlindDown, "contact_form_error", :duration => 0.2
      page.show 'contact_form_submit_button'
    end
  end
  
  def create_mortgage_renew_request
    if params[:renew][:name].blank? || params[:renew][:email].blank? || params[:renew][:maturity_date].blank?
      flash[:error] = 'Please fill out all fields'
    else
      User.notified_admins.each do |admin|
        AdminNotifier::deliver_mortgage_renew_request(admin, params[:renew])
      end
      flash[:notice] = 'Thank you. Your enquiry has been forwarded'
    end
    redirect_to '/mortgage-renewal'
  end
  
  def best_mortgage_rates
    @rate_pages , @rates = paginate :rates
    @user = User.find_by_webpage_address(params[:webpage_address]) if @agent_area
    respond_with_404 if (@user.nil? && @agent_area)
  end
  
  def agents
    conditions = user_search_parameters('users')
    conditions = conditions ? "(" + conditions + ") AND users.is_active = 1" : "users.is_active = 1"
    @user_pages, @users = paginate  :users, 
                                    :per_page => 10, 
                                    :order => "CONCAT(first_name, ' ', last_name)",
                                    :conditions => conditions
  end  

private

  def full_path(file)
    "#{RAILS_ROOT}/app/views/content/#{file}.haml"
  end
  
end