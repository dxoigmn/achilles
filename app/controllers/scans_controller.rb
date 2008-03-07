class ScansController < ApplicationController
  # GET /scans
  # GET /scans.xml
  def index
    @scans = Scan.find(:all, :include => :locations)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @scans }
    end
  end

  # GET /scans/1
  # GET /scans/1.xml
  def show
    @scan = Scan.find(params[:id], :include => :locations)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @scan }
    end
  end
  
  # GET /scans/new
  # GET /scans/new.xml
  def new
    @scan = Scan.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @scan }
    end
  end
  
  # POST /scans
  # POST /scans.xml
  def create
    @scan = Scan.new(params[:scan])

    respond_to do |format|
      if @scan.save
        flash[:notice] = 'Scan was successfully created.'
        format.html { redirect_to(@scan) }
        format.xml  { render :xml => @scan, :status => :created, :location => @scan }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @scan.errors, :status => :unprocessable_entity }
      end
    end
  end
end
