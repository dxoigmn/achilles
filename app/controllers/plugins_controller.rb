class PluginsController < ApplicationController
  # GET /plugins
  # GET /plugins.xml
  def index
    @plugins = Plugin.find(:all, :include => :classification)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /plugins/1
  # GET /plugins/1.xml
  def show
    @plugin = Plugin.find(params[:id], :include => :hosts)

    respond_to do |format|
      format.html # show.html.erb
    end
  end
end
