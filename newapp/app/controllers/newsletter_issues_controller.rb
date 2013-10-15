class NewsletterIssuesController < ApplicationController
  verify :method => :post,    :only => :create,   :redirect_to => { :action => :index }
  verify :method => :put,     :only => :update,   :redirect_to => { :action => :index }
  verify :method => :delete,  :only => :destroy,  :redirect_to => { :action => :index }
  
  before_filter :login_required
  before_filter :load_newsletter
  
  def index
    @newsletter_issue_pages, @newsletter_issues = paginate :newsletter_issues, :conditions => "newsletter_id = #{params[:newsletter_id]}", :per_page => 10, :order => 'status, created_at DESC'
  end

  def show
    @newsletter_issue = NewsletterIssue.find(params[:id])
  end
  
  def new
    @newsletter_issue = NewsletterIssue.new
  end

  def create
    @newsletter_issue = NewsletterIssue.new(params[:newsletter_issue])
    @newsletter_issue.newsletter_id = params[:newsletter_id]
    @newsletter_issue.save!
    flash[:notice] = 'The newsletter issue was successfully created.'
    redirect_to newsletter_issues_path
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

  def edit
    @newsletter_issue = NewsletterIssue.find(params[:id])
    if @newsletter_issue.sent?
      flash[:error] = "#{@newsletter_issue.subject} has already been sent and cannot be edited anymore." 
      redirect_to newsletter_issues_path and return
    end 
  end

  def update
    @newsletter_issue = NewsletterIssue.find(params[:id])   
    if @newsletter_issue.sent?
      flash[:error] = "#{@newsletter_issue.subject} has already been sent and cannot be edited anymore." 
      redirect_to newsletter_issues_path(@newsletter)
    else 
      if @newsletter_issue.update_attributes(params[:newsletter_issue])          
        flash[:notice] = 'The newsletter was issue successfully updated.'
        redirect_to newsletter_issues_path and return
      else
        render :action => 'edit'
      end
    end
  end
  
  def destroy
    @newsletter_issue = NewsletterIssue.find(params[:id])  
    if @newsletter_issue.sent?
      flash[:error] = "#{@newsletter_issue.subject} has already been sent and cannot be edited anymore." 
    else 
      @newsletter_issue.destroy
      flash[:notice] = 'The newsletter issue was deleted.'
    end
    redirect_to newsletter_issues_path(@newsletter)
  end 

  def schedule_for_sending
    @newsletter_issue = NewsletterIssue.find(params[:id])   
    @newsletter_issue.schedule_for_sending
    @newsletter_issue.save
    flash[:notice] = "#{@newsletter_issue.subject} is now scheduled for sending tonight at midnight. You can still edit it until it has been sent."
    redirect_to newsletter_issues_path(@newsletter)
  end
  
  def unschedule_for_sending
    @newsletter_issue = NewsletterIssue.find(params[:id])   
    @newsletter_issue.unschedule_for_sending
    @newsletter_issue.save
    flash[:notice] = "#{@newsletter_issue.subject} scheduling is cancelled."
    redirect_to newsletter_issues_path(@newsletter)
  end

  def test_send
    @newsletter_issue = NewsletterIssue.find(params[:id]) 
    ContactNotifier::deliver_newsletter_issue(current_user, @newsletter_issue)
    flash[:notice] = "A test of <b>#{@newsletter_issue.subject}</b> has been sent to you. Please check your email."
    redirect_to newsletter_issues_path(@newsletter)
  end
  
  def copy
    old_newsletter_issue = NewsletterIssue.find(params[:id])
    @newsletter_issue = NewsletterIssue.new
    @newsletter_issue.newsletter_id = old_newsletter_issue.newsletter_id
    @newsletter_issue.subject = "Copy of #{old_newsletter_issue.subject}"
    @newsletter_issue.text = old_newsletter_issue.text        
    @newsletter_issue.html = old_newsletter_issue.html
    @newsletter_issue.plain_text = old_newsletter_issue.plain_text
    @newsletter_issue.status = UNSCHEDULED
    @newsletter_issue.save!    
    flash[:notice] = "#{@newsletter_issue.subject} has been created."    
    redirect_to edit_newsletter_issue_path(@newsletter_issue.newsletter_id, @newsletter_issue)
  end  
    
protected
  def load_newsletter
    @newsletter = Newsletter.find params[:newsletter_id]
  end
       
  def authorized?
    is_admin?
  end
   
end
