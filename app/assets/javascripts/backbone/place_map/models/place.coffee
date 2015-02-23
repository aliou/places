class App.Models.Place extends Backbone.Model

  initialize: (slug) =>
    @set 'slug', slug if slug

  urlRoot: =>
    if @collection then '' else '/places/'

  url: =>
    @urlRoot() + @get('slug')

  toFeatureLayer: =>
    return L.mapbox.featureLayer {
      type: 'Feature',
      geometry:   {
        type: 'Point',
        coordinates: [ @get('lng'), @get('lat') ]
      },
      properties: {
        title: @get('name'),
        description: @get('address'),
        placeId: @get('id'),
        'marker-size': 'large',
      }
    }
