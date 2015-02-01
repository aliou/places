var PlaceMap = new Backbone.Marionette.Application();

PlaceMap.addRegions({
  container: '#map-wrapper'
});

PlaceMap.addInitializer(function(options) {
  var view = new PlaceMap.Views.MapView({
    collection: new PlaceMap.Models.PlacesCollection()
  });

  PlaceMap.container.show(view);
});

PlaceMap.on('start', function(options) {
  Backbone.history.start({ pushState: true });
});
