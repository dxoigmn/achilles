class HostsController < ApplicationController
  # GET /hosts
  # GET /hosts.xml
  def index
    @hosts = Host.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @hosts }
    end
  end

  # GET /hosts/1
  # GET /hosts/1.xml
  def show
    @host = Host.find(params[:id], :include => { :vulnerabilities => :plugin })

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @host }
    end
  end
end
