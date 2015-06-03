class PlacesController < ApplicationController
  include MapHelper
  before_action :set_place, only: [:show, :update, :destroy]

  respond_to :json

  def index
    @places = PlaceFilterer.new(filter_params, current_user).places

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

  # Private: Permitted parameters for Place filtering.
  #
  # Returns a Hash with the permitted parameters.
  def filter_params
    params.permit(:zoom, :origin => [])
  end
end
