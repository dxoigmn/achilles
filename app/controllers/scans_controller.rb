class ScansController < ApplicationController
  def index
    @scans = Scan.find(:all,
                       :include => [:locations],
                       :page => {:current => params[:page], :size => 15},
                       :order => 'scans.starts_at ASC')
  end

  def show
    @scan = Scan.find(params[:id],
                      :include => [:locations])
    
    @hosts = Host.find_all_by_scan_id(@scan.id,
                                      :page => { :current => params[:page], :size => 15 },
                                      :include => [:location])
  end
  
  def new
    @scan       = Scan.new
    @locations  = Location.find(:all)
  end

  def create
    params[:scan][:starts_at] = Chronic.parse(params[:scan][:starts_at])

    @scan = Scan.new(params[:scan])

    respond_to do |format|
      if @scan.save
        flash[:notice] = 'Scan was successfully created.'
        format.html { redirect_to(@scan) }
      else
        flash[:error] = 'Failed to create scan. Please try again.'
        format.html { render :action => :new }
      end
    end
  end
end
