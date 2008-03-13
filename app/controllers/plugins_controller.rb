class PluginsController < ApplicationController
  def index
    @plugins = Plugin.find(:all, :include => :classification, :page => { :current => params[:page], :size => 15 })
  end

  def show
    @plugin = Plugin.find(params[:id], :include => :hosts)
  end
  
  def edit
    @plugin = Plugin.find(params[:id])
  end
  
  def update
    @plugin = Plugin.find(params[:id])

    respond_to do |format|
      if @plugin.update_attributes(params[:plugin])
        flash[:notice] = 'Plugin was successfully updated.'
        format.html { redirect_to(@plugin) }
      else
        flash[:notice] = 'Failed to update plugin. Please try again.'
        format.html { render :action => "edit" }
      end
    end
  end
end
