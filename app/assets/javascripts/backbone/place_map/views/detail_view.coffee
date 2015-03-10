class App.Views.DetailView extends Backbone.Marionette.ItemView
  el: '#detail'
  template: false

  ui:
    'star': '#star'

  events:
    'click @ui.star': 'toggleStar'

  initialize: (option) =>
    @model = options.model

  # Public: Toggle the whether the Place is starred or not.
  #
  # Returns a Boolean.
  toggleStar: (event) =>
    @model.toggleStarred()
