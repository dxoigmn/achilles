class VulnerabilitiesController < ApplicationController
  # GET /vulnerabilities
  # GET /vulnerabilities.xml
  def index
    @vulnerabilities = Vulnerability.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vulnerabilities }
    end
  end

  # GET /vulnerabilities/1
  # GET /vulnerabilities/1.xml
  def show
    @vulnerability = Vulnerability.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vulnerability }
    end
  end
  
  # GET /vulnerabilities/1/edit
  def edit
    @vulnerability = Vulnerability.find(params[:id])
  end

  # PUT /vulnerabilities/1
  # PUT /vulnerabilities/1.xml
  def update
    @vulnerability = Vulnerability.find(params[:id])

    respond_to do |format|
      if @vulnerability.update_attributes(params[:vulnerability])
        flash[:notice] = 'Vulnerability was successfully updated.'
        format.html { redirect_to(@vulnerability) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vulnerability.errors, :status => :unprocessable_entity }
      end
    end
  end
end
