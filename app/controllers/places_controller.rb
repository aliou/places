class PlacesController < ApplicationController

  # GET /places
  # TODO: Return everything as JSON.
  # TODO: Order by closest aroud you.
  def index
    @places = current_user.places
    @models = ActiveModel::ArraySerializer.new(@places,
                                               each_serializer: PlaceSerializer)
  end

  # GET /places/new
  def new
    @places = current_user.places.new
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
    @place = current_user.places.new params[:place]

    respond_to do |format|
      if @place.save
        format.html { redirect_to place_path(@place),
                      flash: { success: 'Place successfuly created.' } }
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
      if @place.update_attributes params[:place]
        format.html { redirect_to place_path(@place),
                      flash: { success: 'Place successfuly created.' } }
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
                    notice: 'Place successfuly deleted.' }
    end
  end

  # GET /places/import
  # Import places from 4sq.
  # This should be done in a worker/asynchronously.
  def import
    current_user.import_places
    redirect_to places_path, notice: 'Places successfully imported.'
  end
end
