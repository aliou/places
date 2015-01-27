PlaceMap.module('Models', function(Module, App, Backbone, Marionette, $, _) {

  Module.PlacesCollection = Backbone.Collection.extend({
    model: Module.Place,
    url: '/places/'
  });

});
