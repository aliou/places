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
  }
}
