class VulnerabilitiesController < ApplicationController
  def index
    @vulnerabilities = Vulnerability.find(:all,
                                          :page => {:current => params[:page], :size => session[:user].page_size},
                                          :include => [:host, :status],
                                          :conditions => {'hosts.location_id' => session[:user].locations},
                                          :order => 'statuses."default" DESC, vulnerabilities.severity DESC, vulnerabilities.port ASC')
  end
  
  def show
    @vulnerability = Vulnerability.find(params[:id],
                                        :include => [:plugin, :host, :status],
                                        :conditions => {'hosts.location_id' => session[:user].locations})
  end
  
  def edit
    @vulnerability = Vulnerability.find(params[:id],
                                        :include => [:host],
                                        :conditions => {'hosts.location_id' => session[:user].locations})
  end
  
  def update
    @vulnerability = Vulnerability.find(params[:id],
                                        :include => [:host],
                                        :conditions => {'hosts.location_id' => session[:user].locations})

    respond_to do |format|
      if @vulnerability.update_attributes(params[:vulnerability])
        flash[:notice] = 'Vulnerability was successfully updated.'
        format.html { redirect_to(@vulnerability) }
      else
        flash[:error] = 'Failed to update vulnerability. Please try again.'
        format.html { render :action => :edit }
      end
    end
  end
end
