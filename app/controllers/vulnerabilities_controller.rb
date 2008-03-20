class VulnerabilitiesController < ApplicationController
  def show
    @vulnerability = Vulnerability.find(params[:id])
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
        flash[:error] = 'Failed to update vulnerability. Please try again.'
        format.html { render :action => :edit }
      end
    end
  end
end
