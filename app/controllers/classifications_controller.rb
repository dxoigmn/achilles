class ClassificationsController < ApplicationController
  def index
    @classifications = Classification.find(:all,
                                           :page => {:current => params[:page], :size => session[:user].page_size})
  end

  def new
    @classification = Classification.new
  end

  def create
    @classification = Classification.new(params[:classification])

    respond_to do |format|
      if @classification.save
        flash[:notice] = 'Classification was successfully created.'
        format.html { redirect_to(:action => :index) }
      else
        flash[:error] = 'Failed to create classification. Please try again.'
        format.html { render :action => :new }
      end
    end
  end


  def edit
    @classification = Classification.find(params[:id])
  end

  def update
    @classification = Classification.find(params[:id])

    respond_to do |format|
      if @classification.update_attributes(params[:classification])
        flash[:notice] = 'Classification was successfully updated.'
        format.html { redirect_to(:action => :index) }
      else
        flash[:error] = 'Failed to update classification. Please try again.'
        format.html { render(:action => :edit) }
      end
    end
  end
end
