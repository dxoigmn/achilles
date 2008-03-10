class PluginsController < ApplicationController
  def index
    @plugins = Plugin.find(:all, :include => :classification)
  end

  def show
    @plugin = Plugin.find(params[:id], :include => :hosts)
  end
end
