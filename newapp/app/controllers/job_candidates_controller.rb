class JobCandidatesController < ApplicationController
  verify :method => :post,    :only => :create,   :redirect_to => { :action => :index }
  verify :method => :delete,  :only => :destroy,  :redirect_to => { :action => :index }

  before_filter       :load_candidate,    :except => [:index, :new, :create]
  skip_before_filter  :login_required,    :only => [:new, :create]
  before_filter       :flag_public_area,  :only => :new
    
  def index
    @job_candidate_pages, @job_candidates = paginate  :job_candidates, 
                                                      :per_page => 20,
                                                      :order => 'created_at desc'
  end

  def show; end

  def new
    @job_candidate = JobCandidate.new
    @career_reports = CareerReport.find(:all)

    store_location if params[:public_area]
  end

  def create
    @job_candidate = JobCandidate.new(params[:job_candidate])
    if @job_candidate.save
      redirect_back_or_default job_candidates_path
      flash[:notice] = 'The career reports were successfully emailed to you. <br/>You should receive them shortly, thank you.'
      session[:show_careers_conversion] = true
    else
      @career_reports = CareerReport.find(:all)
      render :action => 'new'
    end
  end

  def destroy
    @job_candidate.destroy
    redirect_to job_candidates_path
  end
 
 private
   def load_candidate
     @job_candidate = JobCandidate.find(params[:id])
   end 
     
  def authorized?
    is_admin?
  end
end
