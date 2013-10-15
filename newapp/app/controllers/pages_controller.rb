class PagesController < ApplicationController
  verify :method => :post,    :only => :create,   :redirect_to => { :action => :index }
  verify :method => :put,     :only => :update,   :redirect_to => { :action => :index }
  verify :method => :delete,  :only => :destroy,  :redirect_to => { :action => :index }

  before_filter :load_page, :except => [:index, :new, :create]

  def index
    @pages = Page.find :all, :order => 'name'
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])
    if @page.save
      redirect_to pages_path
      flash[:notice] = 'Page was successfully created.'
    else
      render :action => 'new'
    end
  end

  def edit; end

  def update
    if @page.update_attributes(params[:page])
      flash[:notice] = 'Page was successfully updated.'
      redirect_to pages_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @page.destroy
    redirect_to pages_path
  end

  private  
    def load_page
      @page = Page.find(params[:id])
    end
    
    def authorized?
      is_admin?
    end      
end
