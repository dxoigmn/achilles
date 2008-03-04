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

  # GET /plugins/new
  # GET /plugins/new.xml
  def new
    @plugin = Plugin.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @plugin }
    end
  end

  # GET /plugins/1/edit
  def edit
    @plugin = Plugin.find(params[:id])
  end

  # POST /plugins
  # POST /plugins.xml
  def create
    @plugin = Plugin.new(params[:plugin])

    respond_to do |format|
      if @plugin.save
        flash[:notice] = 'Plugin was successfully created.'
        format.html { redirect_to(@plugin) }
        format.xml  { render :xml => @plugin, :status => :created, :location => @plugin }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @plugin.errors, :status => :unprocessable_entity }
      end
    end
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

  # DELETE /plugins/1
  # DELETE /plugins/1.xml
  def destroy
    @plugin = Plugin.find(params[:id])
    @plugin.destroy

    respond_to do |format|
      format.html { redirect_to(plugins_url) }
      format.xml  { head :ok }
    end
  end
end
