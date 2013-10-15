class RatesController < ApplicationController
  verify :method => :post,    :only => :create,   :redirect_to => { :action => :index }
  verify :method => :put,     :only => :update,   :redirect_to => { :action => :index }
  verify :method => :delete,  :only => :destroy,  :redirect_to => { :action => :index }

  before_filter       :load_rate,       :except => [:index, :new, :create]
  
  def index
    @rate_pages , @rates = paginate :rates
  end

  def new
    @rate = Rate.new
  end

  def create
    @rate = Rate.new(params[:rate])
    if @rate.save
      redirect_to rates_path
      flash[:notice] = 'Rate was successfully created.'
    else
      render :action => 'new'
    end
  end

  def edit; end

  def update
    if @rate.update_attributes(params[:rate])
      flash[:notice] = 'Rate was successfully updated.'
      redirect_to rates_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @rate.destroy
    redirect_to rates_path
  end

  private  
    def load_rate
      @rate = Rate.find(params[:id])
    end
    
    def authorized?
      is_admin?
    end      
end
