class Place extends Backbone.Model {
  constructor() {
    super();
  }

  toGeoJSON() {
    return {};
  }
}

class _PlaceStore extends Backbone.Collection {
  constructor(options) {
    super(options);

    // this.model = Place;
    this.url = '/places';
    this.dispatchToken =
      PlaceDispatcher.register(this.dispatchCallback.bind(this));
  }

  getPlacesAround(location, zoom = 13) {
    const options = { origin: location, zoom: zoom };
    this.fetch({ data: $.param(options), reset: true });
  }

  dispatchCallback(payload) {
    switch(payload.actionType) {
      case ActionTypes.INITIAL_FETCH:
        this.getPlacesAround(payload.data.location, payload.data.zoom);
        break;
    }
  }
}
