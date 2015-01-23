PlaceMap.module('Views', function(Module, App, Backbone, Marionette, $, _) {
  Module.MapView = Backbone.Marionette.CollectionView.extend({
    // tagName: 'div',
    // id: 'map',

    template: '#mapVenue-template',
    events: {
      'click #find-me': 'locateUser',
      'locationfound':  'setUserLocation'
    },

    initialize: function() {
      // TODO: Rename this file as ERB and use ruby variable.
      // L.mapbox.accessToken = "#{ENV['MAPBOX_ACCESS_TOKEN']}"

      // this.map = L.mapbox.map('map', 'examples.map-i86nkdio').setView([48.85, 2.35], 13)
      // this.map.attributionControl.addAttribution('<a href="https://foursquare.com/">Places data from Foursquare</a>')

      _.bindAll(this, 'locateUser', 'setUserLocation');
    },

    locateUser: function() {
      if (navigator.geolocation) {
        this.map.locate()
      }
    },

    setUserLocation: function(event) {
      this.map.setView([event.latitude, event.longitude], 13)

      L.mapbox.featureLayer({
        type:       'Feature',
        geometry:   {
          type:        'Point',
          coordinates: [event.longitude, event.latitude]
        },
        properties: {
          'marker-color': '#BE9A6B',
          'marker-symbol': 'star',
        }
      }).addTo(this.map)
    },

  });
});
