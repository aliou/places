class Place extends Backbone.Model {
  constructor() {
    super();
  }
}

class PlaceStore extends Backbone.Collection {
  constructor(options) {
    super(options);

    this.model = Place;
    this.url = '/places';
  }

  getPlacesAround(location, zoom = 16) {
    const options = { origin: location, zoom: zoom };
    this.fetch({ data: $.param(options), reset: true });
  }
}
