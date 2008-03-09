class ClassificationsController < ApplicationController
  # GET /classifications
  # GET /classifications.xml
  def index
    @classifications = PluginClassification.find(:all)

    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
