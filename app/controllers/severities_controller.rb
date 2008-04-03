class SeveritiesController < ApplicationController
  def index
    @severities = Severity.find(:all,
                                :include => [:location, :classification],
                                :conditions => { :location_id => session[:user].locations },
                                :order => 'locations.name, classifications.name')
  end

  def edit
    @severity = Severity.find(params[:id],
                              :include => [:location, :classification],
                              :conditions => { :location_id => session[:user].locations })
  end

  def update
    @severity = Severity.find(params[:id],
                              :conditions => { :location_id => session[:user].locations })

    respond_to do |format|
      if @severity.update_attributes(params[:severity])
        flash[:notice] = 'Severity was successfully updated.'
        format.html { redirect_to(:action => :index) }
      else
        flash[:error] = 'Failed to update severity. Please try again.'
        format.html { render :action => :edit }
      end
    end
  end
end
