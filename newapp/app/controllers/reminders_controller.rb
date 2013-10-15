class RemindersController < ApplicationController

  verify :method => :post,    :only => :create,   :redirect_to => { :action => :index }
  verify :method => :put,     :only => :update,   :redirect_to => { :action => :index }
  verify :method => :delete,  :only => :destroy,  :redirect_to => { :action => :index }

  before_filter :load_user, :load_contact


  def index
    @reminder_pages, @reminders = paginate :reminders, :per_page => 10
  end

  def create
    @reminder = Reminder.new(params[:reminder])
    if @reminder.save
      @contact.reminders << @reminder  
    else
      render :update do |page| 
        page.hide 'reminder_add_icon'
        page.alert(@reminder.errors.full_messages)
      end
    end
  end

  def update
    @reminder = Reminder.find(params[:id])
    if @reminder.update_attributes(params[:reminder])
      flash[:notice] = 'Reminder was successfully updated.'
    else
      render :update do |page| 
        page.hide "reminder_edit_icon_#{@reminder.id}"
        page.alert(@reminder.errors.full_messages)
      end
    end
  end

  def destroy
    @reminder = @contact.reminders.find(params[:id])
    @reminder.destroy
    render :update do |page|
      page.visual_effect :highlight, "reminder_show_#{@reminder.id}", :duration => 1
      page.visual_effect :Fade, "reminder_#{@reminder.id}"
    end
  end
  
  
  private  
    def authorized?
      is_admin? || params[:user_id] == current_user.id.to_s
    end
  
end
