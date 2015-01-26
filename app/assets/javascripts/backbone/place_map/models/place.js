PlaceMap.module('Models', function(Module, App, Backbone, Marionette, $, _) {

  Module.Place = Backbone.Model.extend({
    toFeatureLayer: function() {
      return L.mapbox.featureLayer({
        type:       'Feature',
        geometry:   {
          type:        'Point',
          coordinates: [ this.get('lng'), this.get('lat') ]
        },
        properties: {
          title:           this.get('name'),
          description:     this.get('address'),
          'marker-size':   'large',
        }
      })
    }
  });

});