var PlaceMap = new Backbone.Marionette.Application();

PlaceMap.addRegions({
  container: '#map-wrapper'
});

PlaceMap.addInitializer(function(options) {
  var collection = new PlaceMap.Models.PlacesCollection();
  var view = new PlaceMap.Views.MapView({ collection: collection });

  PlaceMap.container.show(view);
});

PlaceMap.on('start', function(options) {
  Backbone.history.start();
});
