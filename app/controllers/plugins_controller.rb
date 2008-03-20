class PluginsController < ApplicationController
  def index
    @plugins = Plugin.find(:all, :page => {:current => params[:page], :size => 15}, :order => 'plugins.name ASC')
  end

  def show
    @plugin = Plugin.find(params[:id])
  end
  
  def edit
    @plugin = Plugin.find(params[:id])
  end
  
  def update
    @plugin = Plugin.find(params[:id])

    updated = @plugin.update_attributes(params[:plugin])

    params[:plugin_severities].each do |id, values|
      plugin_severity = PluginSeverity.find(id)
      updated &&= plugin_severity.update_attributes(values)
    end
    
    respond_to do |format|
      if updated
        flash[:notice] = 'Plugin was successfully updated.'
        format.html { redirect_to(@plugin) }
      else
        flash[:error] = 'Failed to update plugin. Please try again.'
        format.html { render :action => :edit }
      end
    end
  end
end
