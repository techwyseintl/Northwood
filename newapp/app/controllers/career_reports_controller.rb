class CareerReportsController < ApplicationController
  verify :method => :post,    :only => :create,   :redirect_to => { :action => :index }
  verify :method => :put,     :only => :update,   :redirect_to => { :action => :index }
  verify :method => :delete,  :only => :destroy,  :redirect_to => { :action => :index }
  
  def index
    @career_reports = CareerReport.find(:all, :order => "name, filename")
  end

  def create
    @career_report = CareerReport.new(params[:career_report])
    if @career_report.save
      flash[:notice] = 'The Career Report was successfully created.'
      redirect_to career_reports_path
    else
      @career_reports = CareerReport.find(:all, :order => "name, filename")
      render :action => :index
    end
  end

  def destroy
    CareerReport.find(params[:id]).destroy
    flash[:notice] = 'The report was deleted from the system.'
    redirect_to career_reports_path
  end
end
