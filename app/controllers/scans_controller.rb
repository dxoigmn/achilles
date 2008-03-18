class ScansController < ApplicationController
  def index
    @scans = Scan.find(:all,
                       :include => :locations,
                       :page => {:current => params[:page], :size => 15},
                       :order => 'scans.starts_at ASC')
  end

  def show
    @scan = Scan.find(params[:id],
                      :include => [{:hosts => {:vulnerabilities => [:severity, :plugin]}}, :locations])
  end
  
  def new
    @scan = Scan.new
  end

  def create
    @scan = Scan.new(params[:scan])
    
    p @scan.locations

    respond_to do |format|
      if @scan.save
        flash[:notice] = 'Scan was successfully created.'
        format.html { redirect_to(@scan) }
      else
        flash[:error] = 'Failed to create scan. Please try again.'
        format.html { render :action => "new" }
      end
    end
  end
end
