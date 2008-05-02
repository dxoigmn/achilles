class PluginsController < ApplicationController
  def index
    @plugins = Plugin.find(:all,
                           :page => {:current => params[:page], :size => session[:user].page_size},
                           :include => [:classification],
                           :order => 'plugins.name ASC')
  end

  def show
    @plugin = Plugin.find(params[:id],
                          :include => [:classification, :family, :risk, {:plugin_severities => :location}],
                          :conditions => {'locations.id' => session[:user].locations},
                          :order => 'locations.name ASC')
    
    @vulnerabilities  = Vulnerability.find_all_by_plugin_id(@plugin.id,
                                                            :page => { :current => params[:page], :size => session[:user].page_size},
                                                            :include => [:host, :status],
                                                            :conditions => {'hosts.location_id' => session[:user].locations},
                                                            :order => 'statuses."default" DESC, hosts.name ASC, vulnerabilities.severity DESC, vulnerabilities.port ASC')
  end
  
  def edit
    @plugin = Plugin.find(params[:id],
                          :include => [:classification, :family, :risk, {:plugin_severities => :location}],
                          :conditions => {'locations.id' => session[:user].locations},
                          :order => 'locations.name ASC')
  end
  
  def update
    @plugin = Plugin.find(params[:id])

    updated = @plugin.update_attributes(params[:plugin])

    params[:plugin_severities].each do |id, values|
      plugin_severity = PluginSeverity.find(id,
                                            :conditions => {'location_id' => session[:user].locations})
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
