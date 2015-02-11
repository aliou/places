class App.Collections.Places extends Backbone.Collection
  model: App.Models.Place
  url: '/places/'

  # Public: Finds a Place in the collection using its slug.
  #
  # slug - The slug of the Place to find.
  #
  # Returns a Place or nothing.
  bySlug: (slug) =>
    @findWhere { slug: slug }
