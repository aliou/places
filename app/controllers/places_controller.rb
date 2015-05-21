class PlacesController < ApplicationController
  include MapboxHelper
  before_action :set_place, only: [:show, :update, :destroy]

  # GET /places
  def index
    respond_to do |format|
      format.html
      format.json do
        render json: filtered_places, root: false
      end
    end
  end

  # POST /places
  def create
    @place = current_user.places.new(place_params)

    respond_to do |format|
      if @place.save
        format.html { redirect_to place_path(@place),
                      flash: { success: I18n.t('place.create.flash.success') } }
      else
        format.html { render action: :edit }
      end
    end
  end

  # PUT   /places/:id
  # PATCH /places/:id
  def update
    @place = Place.find params[:id]

    respond_to do |format|
      if @place.update_attributes(place_params)
        format.html { redirect_to place_path(@place),
                      flash: { success: I18n.t('place.update.flash.success') } }
      else
        format.html { render action: :edit }
      end
    end
  end

  # DELETE /places/:id
  def destroy
    @place.destroy
    respond_to do |format|
      format.html { redirect_to places_path,
                    notice: I18n.t('place.destroy.flash.notice') }
    end
  end

  # GET /places/import
  # TODO: Response when the request is from async.
  def import
    PlaceImportJob.perform_later(current_user)
    respond_to do |format|
      format.html { redirect_to places_path,
                                notice: I18n.t('place.import.flash.notice') }
    end
  end

  private

  # Private: Set the place
  #
  # @return a Place.
  def set_place
    @place = Place.find(params[:id])
  end

  # Private: Permitted parameters for Place creation and update.
  #
  # Returns a Hash with the permitted parameters.
  def place_params
    params.require(:place).permit(:name, :lat, :lng, :foursquare_venue_id)
  end

  # Private: Filter the places by their distance to the origin and the map zoom,
  # if given.
  #
  # Returns an Array of Places.
  def filtered_places
    if params[:origin] and params[:zoom]
      radius = zoom_to_radius(params[:zoom].to_f, params[:origin][0].to_f)
      current_user.places.includes(:category)
        .within(radius, origin: params[:origin])
    else
      current_user.places.includes(:category)
    end
  end
end
