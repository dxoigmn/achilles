class VulnerabilitiesController < ApplicationController
  def index
    @vulnerabilities = Vulnerability.find(:all, :include => [:severity, :plugin], :page => { :current => params[:page], :size => 15 })
  end

  def show
    @vulnerability = Vulnerability.find(params[:id], :include => { :plugin => [:family, :status, :risk, :classification], :host => [], :severity => [] })
  end
  
  def edit
    @vulnerability = Vulnerability.find(params[:id])
  end
  
  def update
    @vulnerability = Vulnerability.find(params[:id])

    respond_to do |format|
      if @vulnerability.update_attributes(params[:vulnerability])
        flash[:notice] = 'Vulnerability was successfully updated.'
        format.html { redirect_to(@vulnerability) }
      else
        flash[:notice] = 'Failed to update vulnerability. Please try again.'
        format.html { render :action => "edit" }
      end
    end
  end
end
