class App.Router.Places extends Backbone.Router

  routes: {
    '(/)': 'index',
    ':slug(/)': 'show'
  }

  initialize: ->
    App.Cache.collection = new App.Collections.Places

  index: ->
    mapView = new App.Views.MapView {
      collection: App.Cache.collection
    }
    App.map.show(mapView)

  show: (slug) ->
    App.map.$el.hide()
    place = new App.Models.Place(slug)

    detailView   = new App.Views.DetailView(model: place)
    metadataView = new App.Views.MetadataView(model: place)

    App.detail.show(detailView)
    App.meta.show(metadataView)
