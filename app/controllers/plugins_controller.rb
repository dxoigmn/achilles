class PluginsController < ApplicationController
  def index
    @plugins = Plugin.find(:all, :page => {:current => params[:page], :size => 15}, :order => 'plugins.name ASC')
  end

  def show
    @plugin = Plugin.find(params[:id])
    @locations = Location.find(:all, :order => 'locations.name')
  end
  
  def edit
    @plugin     = Plugin.find(params[:id])
    @locations  = Location.find(:all, :order => 'name')
  end
  
  def update
    @plugin = Plugin.find(params[:id])

    respond_to do |format|
      if @plugin.update_attributes(params[:plugin])
        flash[:notice] = 'Plugin was successfully updated.'
        format.html { redirect_to(@plugin) }
      else
        flash[:error] = 'Failed to update plugin. Please try again.'
        format.html { render :action => :edit }
      end
    end
  end
end
