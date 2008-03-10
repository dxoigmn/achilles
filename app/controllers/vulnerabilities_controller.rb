class VulnerabilitiesController < ApplicationController
  def index
    @vulnerabilities = Vulnerability.find(:all)
  end

  def show
    @vulnerability = Vulnerability.find(params[:id], :include => [:plugin, :host])
  end
end
