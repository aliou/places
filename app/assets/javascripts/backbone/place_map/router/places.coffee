class App.Router.Places extends Backbone.Router

  routes: {
    '(/)': 'index',
    ':slug(/)': 'show'
  }

  initialize: ->
    App.Cache.mapView = new App.Views.MapView {
      collection: new App.Collections.Places
    }

  index: ->
    App.container.show(App.Cache.mapView)

  show: (slug) ->
    App.container.show(App.Cache.mapView)
    model = new App.Models.Place(slug)
