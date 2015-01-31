class PlacesController < ApplicationController

  # GET /places
  # TODO: Order by closest around you.
  def index
    respond_to do |format|
      format.html
      format.json do
        render json: filtered_places,
          root: false, each_serializer: PlaceSerializer
      end
    end
  end

  # GET /places/new
  def new
    @place = current_user.places.new
  end

  # GET /places/:id/edit
  def edit
    @place = Place.find params[:id]
  end

  # GET /places/:id
  def show
    @place = Place.find params[:id]
  end

  # POST /places
  def create
    @place = current_user.places.new place_params

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
      if @place.update_attributes place_params
        format.html { redirect_to place_path(@place),
                      flash: { success: I18n.t('place.update.flash.success') } }
      else
        format.html { render action: :edit }
      end
    end
  end

  # DELETE /places/:id
  def destroy
    @place = Place.find params[:id]
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

  # Private: Permitted parameters for Place creation and update.
  #
  # Returns a Hash with the permitted parameters.
  def place_params
    params.require(:place).permit(:name, :lat, :lng, :foursquare_venue_id)
  end

  def filtered_places
    if params[:origin]
      current_user.places.within(10, origin: params[:origin])
    else
      current_user.places
    end
  end
end
