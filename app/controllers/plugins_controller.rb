class PluginsController < ApplicationController
  # GET /plugins
  # GET /plugins.xml
  def index
    @plugins = Plugin.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @plugins }
    end
  end

  # GET /plugins/1
  # GET /plugins/1.xml
  def show
    @plugin = Plugin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @plugin }
    end
  end

  # GET /plugins/1/edit
  def edit
    @plugin = Plugin.find(params[:id])
  end

  # PUT /plugins/1
  # PUT /plugins/1.xml
  def update
    @plugin = Plugin.find(params[:id])

    respond_to do |format|
      if @plugin.update_attributes(params[:plugin])
        flash[:notice] = 'Plugin was successfully updated.'
        format.html { redirect_to(@plugin) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @plugin.errors, :status => :unprocessable_entity }
      end
    end
  end
end
