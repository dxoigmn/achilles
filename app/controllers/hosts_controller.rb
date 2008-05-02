class HostsController < ApplicationController
  def index
    @hosts = Host.find(:all,
                       :page => {:current => params[:page], :size => session[:user].page_size},
                       :conditions => {:location_id => session[:user].locations},
                       :include => [:location],
                       :order => 'hosts.severity DESC, locations.name ASC, hosts.name ASC, hosts.vulnerabilities_count DESC')
  end

  def show
    @host = Host.find(params[:id],
                      :conditions => {:location_id => session[:user].locations},
                      :include => [:location, {:vulnerabilities => [:plugin, :status]}],
                      :order => 'statuses."default" DESC, vulnerabilities.severity DESC, vulnerabilities.port ASC')
  end
  
  def edit
    @host = Host.find(params[:id],
                      :conditions => {:location_id => session[:user].locations})
  end
  
  def update
    @host = Host.find(params[:id],
                      :conditions => {:location_id => session[:user].locations})

    respond_to do |format|
      if @host.update_attributes(params[:host])
        flash[:notice] = 'Host was successfully updated.'
        format.html { redirect_to(@host) }
      else
        flash[:error] = 'Failed to update Host. Please try again.'
        format.html { render :action => :edit }
      end
    end
  end
end
