// TODO: Namespace application.
var PlaceMap = new Backbone.Marionette.Application();

PlaceMap.addRegions({
  container: '#map-wrapper'
});

// TODO: Create router in the namespace of inside the Backbone app.
PlaceMap.addInitializer(function(options) {
  PlaceMap.router = new PlaceMap.Router();
});

PlaceMap.on('start', function(options) {
  Backbone.history.start({ pushState: true });
});
