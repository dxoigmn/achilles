class PluginClassificationsController < ApplicationController
  def index
    @plugin_classifications = PluginClassification.find(:all,
                                                        :include => [:risk, :classification, :family],
                                                        :order => 'risks.name ASC, families.name ASC')
  end

  def edit
    @plugin_classification = PluginClassification.find(params[:id])
  end

  def update
    @plugin_classification = PluginClassification.find(params[:id])

    respond_to do |format|
      if @plugin_classification.update_attributes(params[:plugin_classification])
        flash[:notice] = 'Plugin classification was successfully updated.'
        format.html { redirect_to(:action => :index) }
      else
        flash[:error] = 'Failed to update plugin classification. Please try again.'
        format.html { render(:action => :edit) }
      end
    end
  end
end
