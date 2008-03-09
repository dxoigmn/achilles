class SeveritiesController < ApplicationController
  # GET /severities
  # GET /severities.xml
  def index
    @severities = VulnerabilitySeverity.find(:all)

    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
