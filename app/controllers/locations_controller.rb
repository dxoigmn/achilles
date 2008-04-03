class LocationsController < ApplicationController
  def index
    @locations = Location.find(:all,
                               :page => {:current => params[:page], :size => session[:user].page_size},
                               :conditions => {:id => session[:user].locations})
  end

  def show
    @location = Location.find(params[:id],
                              :conditions => {:id => session[:user].locations})
  end
  
  def edit
    @location = Location.find(params[:id],
                              :conditions => {:id => session[:user].locations})
  end
  
  def new
    @location = Location.new
  end
  
  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        session[:user].locations << @location
        flash[:notice] = 'Location was successfully created.'
        format.html { redirect_to(@location) }
      else
        flash[:error] = 'Failed to create location. Please try again.'
        format.html { render :action => :new }
      end
    end
  end  
  def update
    @location = Location.find(params[:id],
                              :conditions => {:id => session[:user].locations})

    respond_to do |format|
      if @location.update_attributes(params[:location])
        flash[:notice] = 'Location was successfully updated.'
        format.html { redirect_to(@location) }
      else
        flash[:error] = 'Failed to update location. Please try again.'
        format.html { render :action => :edit }
      end
    end
  end
end
