var PlaceMap = new Backbone.Marionette.Application();

PlaceMap.addRegions({
  container: '#map-wrapper'
});

// TODO: Find a better way to save the objects in PlaceMap, so we can access
// them later. (Ex. access the router somewhere else)
PlaceMap.addInitializer(function(options) {
  PlaceMap.router = new PlaceMap.Router();
});

PlaceMap.on('start', function(options) {
  Backbone.history.start({ pushState: true });
});
