class HostsController < ApplicationController
  def index
    @hosts = Host.find(:all)
  end

  def show
    @host = Host.find(params[:id], :include => { :vulnerabilities => :plugin })
  end
end
