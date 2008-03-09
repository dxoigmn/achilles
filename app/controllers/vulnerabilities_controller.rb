class VulnerabilitiesController < ApplicationController
  # GET /vulnerabilities/1
  # GET /vulnerabilities/1.xml
  def show
    @vulnerability = Vulnerability.find(params[:id], :include => [:plugin, :host])

    respond_to do |format|
      format.html # show.html.erb
    end
  end
end
