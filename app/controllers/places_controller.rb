class PlacesController < ApplicationController
  include MapboxHelper
  before_action :set_place, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @places = filtered_places

    respond_to do |format|
      format.json { render json: @places, root: false }
      format.html
    end
  end

  def show
    respond_with(@place, root: false)
  end

  def create
    @place = current_user.places.create(place_params)
    respond_with(@place, root: false)
  end

  def update
    @place.update(place_params)
    respond_with(@place, root: false)
  end

  def destroy
    @place.destroy
    respond_to do |format|
      format.json { head :no_content }
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
