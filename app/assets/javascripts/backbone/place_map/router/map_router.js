PlaceMap.Router = Backbone.Router.extend({
  routes: {
    'places(/)':        'index',
    'places/:place_id': 'show'
  },

  initialize: function() {
    PlaceMap.views.mapView = new PlaceMap.Views.MapView({
      collection: new PlaceMap.Models.PlacesCollection()
    });

    _.bindAll(this, 'index', 'show');
  },

  index: function() {
    PlaceMap.container.show(PlaceMap.views.mapView);
  },

  show: function(placeSlug) {
    var model = PlaceMap.views.mapView.collection.bySlug(placeSlug);
  },
});
