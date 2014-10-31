class PlacesController < ApplicationController

  # TODO: Order by closest aroud you.
  def index
    @places = @current_user.places
  end

  def new
    @places = @current_user.places.new
  end

  def edit
    @place = Place.find params[:id]
  end

  def show
    @place = Place.find params[:id]
  end

  def create
    @place = @current_user.places.new params[:place]

    respond_to do |format|
      if @place.save
        format.html { redirect_to place_path(@place),
                      flash: { success: 'Place successfuly created.' } }
      else
        format.html { render action: :edit }
      end
    end
  end

  def update
    @place = Place.find params[:id]
    respond_to do |format|
      if @place.update_attributes params[:place]
        format.html { redirect_to place_path(@place),
                      flash: { success: 'Place successfuly created.' } }
      else
        format.html { render action: :edit }
      end
    end
  end

  def destroy
    @place = Place.find params[:id]
    @place.destroy
    respond_to do |format|
      format.html { redirect_to places_path,
                    notice: 'Place successfuly deleted.' }
    end
  end
end
