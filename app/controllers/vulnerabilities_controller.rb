class VulnerabilitiesController < ApplicationController
  # GET /vulnerabilities
  # GET /vulnerabilities.xml
  def index
    @vulnerabilities = Vulnerability.find(:all, :include => :plugin)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vulnerabilities }
    end
  end

  # GET /vulnerabilities/1
  # GET /vulnerabilities/1.xml
  def show
    @vulnerability = Vulnerability.find(params[:id], :include => [:plugin, :host])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vulnerability }
    end
  end
end
