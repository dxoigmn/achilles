class HostsController < ApplicationController
  def index
    @hosts = Host.find(:all,
                       :include => {:vulnerabilities => [{:host => :location}, {:plugin => [:plugin_severities, {:classification => :severities}]}]},
                       :page => {:current => params[:page], :size => 15},
                       :order => 'vulnerabilities.severity DESC')
  end

  def show
    @host = Host.find(params[:id],
                      :include => [:location, {:vulnerabilities => [{:host => :location}, {:plugin => [:plugin_severities, {:classification => :severities}]}]}],
                      :order => 'vulnerabilities.severity DESC, vulnerabilities.protocol ASC, vulnerabilities.port ASC, vulnerabilities.service ASC')
  end
  
  def edit
    @host = Host.find(params[:id])
  end
  
  def update
    @host = Host.find(params[:id])

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
