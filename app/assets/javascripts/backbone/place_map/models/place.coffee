class App.Models.Place extends Backbone.Model

  initialize: (slug) =>
    if slug
      @set 'slug', slug
      @fetch()

  # Public: The URL root of the place.
  # If the place is in a collection, this is already take care of.
  # Otherwise, we need to specify it.
  #
  # Returns a String>.
  urlRoot: =>
    if @collection then '' else '/places/'

  # Public: The URL of the place.
  # We use the slug to get the URL.
  #
  # Returns a String.
  url: =>
    @urlRoot() + @get('slug')

  # Public: Toggle star of the model
  #
  # Returns a Boolean>
  toggleStarred: =>
    @set 'starred', !@get('starred')

    @get 'starred'

  # Public: Convert the current Place to a Mapbox FeatureLayer.
  # We fetch the full model before the convertion.
  #
  # Returns a Mapbox FeatureLayer object.
  toFeatureLayer: =>
    @fetch() if !@get('lng')?

    L.mapbox.featureLayer {
      type: 'Feature',
      geometry: {
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
