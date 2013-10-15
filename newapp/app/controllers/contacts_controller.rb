class ContactsController < ApplicationController
  
  verify :method => :post,    :only => :create,   :redirect_to => { :action => :index }
  verify :method => :put,     :only => :update,   :redirect_to => { :action => :index }
  verify :method => :delete,  :only => :destroy,  :redirect_to => { :action => :index }
  
  before_filter :load_user, :except => [:all, :list_unassigned, :show_unassigned, :edit_unassigned, :update, :destroy, :transfer]
      
  def index
    conditions = user_search_parameters('contacts')
    
    conditions = conditions ? "(" + conditions + ") AND users.id = #{@user.id}" : "users.id = #{@user.id}"
    find_params = {
      :order      => 'contacts.first_name',
      :select     => '
        users.id, 
        contacts.id, 
        contacts.first_name, 
        contacts.last_name,
        contacts.mobile,
        contacts.phone, 
        contacts.fax,
        contacts.user_id,
        contacts.email, 
        CONCAT(users.first_name,\' \', users.last_name) as agent',
      :joins      => 'LEFT JOIN users ON(users.id=contacts.user_id)',
      :conditions => conditions
    }
    
    respond_to do |format|
      format.html do
        @contact_pages, @contacts = paginate  :contacts,  find_params.merge(:per_page => 20)
      end
      format.csv do 
        contacts = Contact.find(:all, find_params)
        csv_data = ''
        labels = ['First Name', 'Last Name', 'Phone', 'Mobile', 'Fax', 'Email']
        CSV.generate_row(labels, labels.size, csv_data)
        
        contacts.each do |contact| 
          data = [contact.first_name, contact.last_name, contact.phone, contact.mobile, contact.fax, contact.email]
          CSV.generate_row(data, data.size, csv_data)
        end
        send_data(csv_data, :type => 'text/csv; charset=utf-8; header=present', :filename => 'contacts.csv')
      end
    end
  end

  # Only admin people can see this one, it lists all the contacts
  def all
    @page_header = 'All Contacts'
    conditions = user_search_parameters('contacts')
    
    @contact_pages, @contacts = paginate :contacts, :select => 'contacts.id, contacts.first_name, 
                                                                contacts.last_name, contacts.mobile,
                                                                contacts.phone, contacts.fax, contacts.user_id,
                                                                contacts.email, 
                                                                CONCAT(users.first_name,\' \', users.last_name) as agent,
                                                                users.is_active as agent_is_active',
                                                    :joins => 'LEFT JOIN users ON(users.id=contacts.user_id)',
                                                    :per_page => 20,
                                                    :order => 'agent, contacts.first_name',
                                                    :conditions => conditions
    render :action => 'index'
  end
  
  # Only admin people can see this one, it lists all unassigned contacts
  def list_unassigned
    @page_header = 'Company Contacts'
    
    conditions = user_search_parameters('contacts')
    conditions = conditions ? "(" + conditions + ") AND user_id IS NULL" : "user_id IS NULL"
    @contact_pages, @contacts = paginate :contacts, :per_page => 20,
                                                    :order => 'first_name',
                                                    :conditions => conditions
    render :action => 'index'
  end
  
  def show_unassigned
    @page_header = 'Company Contact'
    @contact = Contact.find(params[:id])
  end
  
  def edit_unassigned
    @page_header = 'Company Contact'
    @contact = Contact.find(params[:id])
  end
  
  def show
    @contact = @user.contacts.find(params[:id])
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.user_id = @user.id
    @contact.save!

    redirect_to contacts_path(@user)
    flash[:notice] = 'Contact was successfully created.'
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

  def edit
    @contact = Contact.find(params[:id], :conditions => "user_id = #{@user.id}")
  end

  def update
    if params[:user_id]
      @user = User.find params[:user_id]
      @contact = Contact.find(params[:id], :conditions => "user_id = #{@user.id}")
    else
      # we're dealing with unassigned user here
      @contact = Contact.find(params[:id])
    end

    # making sure that only admin changes agent associated with contact
    if @user and @contact.user_id != @user.id and !@current_user.is_admin?
      respond_with_403 and return
    end
    
    if @contact.update_attributes(params[:contact])          
      flash[:notice] = 'Contact was successfully updated.'
      redirect_to contact_path(@contact.user, @contact) and return unless !@contact.user
      redirect_to unassigned_contact_path(@contact)
    else
      render :action => 'edit'
    end
  end

  def destroy
    contact = Contact.find(params[:id])
    
    if contact.user_id == nil
      unassigned = true
    end
    
    if @current_user.is_admin? or contact.user == @current_user
      contact.destroy
      if !unassigned
        load_user
        redirect_to contacts_path(@user)
      else
        redirect_to unassigned_contacts_path
      end
    else
      respond_with_403
    end
  end
  
  def transfer
    if @current_user.is_admin?
      Contact.update_all "user_id = #{params[:transfer_to]}", "user_id = #{params[:transfer_from]}"
      flash[:notice] = 'Contacts were successfully transfered.'
      redirect_to contacts_path(params[:transfer_from])      
    end
  end

protected

  def authorized?
    if params[:user_id]
      is_admin? || params[:user_id] == current_user.id.to_s
    else
      is_admin?
    end
  end    
end
