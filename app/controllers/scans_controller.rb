class ScansController < ApplicationController
  def index
    @scans = Scan.find(:all, :include => :locations)
  end

  def show
    @scan = Scan.find(params[:id], :include => :locations)
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
        flash[:error] = 'Unable to save scan.'
        format.html { render :action => "new" }
      end
    end
  end
end
