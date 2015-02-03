PlaceMap.module('Models', function(Module, App, Backbone, Marionette, $, _) {

  Module.Place = Backbone.Model.extend({

    url: function() {
      return this.collection.url + this.get('slug');
    },

    toFeatureLayer: function() {
      return L.mapbox.featureLayer({
        type:       'Feature',
        geometry:   {
          type:        'Point',
          coordinates: [ this.get('lng'), this.get('lat') ]
        },
        properties: {
          title:         this.get('name'),
          description:   this.get('address'),
          placeId:       this.get('id'),
          'marker-size': 'large',
        }
      })
    }
  });

});
