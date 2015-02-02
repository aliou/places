PlaceMap.Router = Backbone.Router.extend({
  routes: {
    'places':           'index',
    'places/:place_id': 'show'
  },

  index: function() {
    var view = new PlaceMap.Views.MapView({
      collection: new PlaceMap.Models.PlacesCollection()
    });

    PlaceMap.container.show(view);
  },

  // TODO: Fetch model and the places around it.
  show: function(placeId) {
    console.log(placeId);
  },
});
