#= require_self
#
#= require ./models/place
#= require ./models/places_collection
#
#= require_tree ./router
#
#= require ./views/map_view

@App = new Backbone.Marionette.Application({
  Cache: {}
  Models: {}
  Collections: {}
  Router: {}
  Views: {}
})

@App.addRegions {
  container: '#map-wrapper'
}

@App.addInitializer (options) =>
  @App.Cache.router = new App.Router.Places()

@App.on 'start', (options) ->
  Backbone.history.start { pushState: true, root: '/places' }

$ =>
  @App.start()
