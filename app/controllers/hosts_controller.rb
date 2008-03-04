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
    @host = Host.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @host }
    end
  end

  # GET /hosts/1/edit
  def edit
    @host = Host.find(params[:id])
  end

  # PUT /hosts/1
  # PUT /hosts/1.xml
  def update
    @host = Host.find(params[:id])

    respond_to do |format|
      if @host.update_attributes(params[:host])
        flash[:notice] = 'Host was successfully updated.'
        format.html { redirect_to(@host) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @host.errors, :status => :unprocessable_entity }
      end
    end
  end
end
