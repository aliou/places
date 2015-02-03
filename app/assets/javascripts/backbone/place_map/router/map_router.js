PlaceMap.Router = Backbone.Router.extend({
  routes: {
    'places(/)':        'index',
    'places/:place_id': 'show'
  },

  initialize: function() {
    this.view = new PlaceMap.Views.MapView({
      collection: new PlaceMap.Models.PlacesCollection()
    });
    _.bindAll(this, 'index', 'show');
  },

  index: function() {
    PlaceMap.container.show(this.view);
  },

  show: function(placeId) {
    console.log(placeId);
  },
});
