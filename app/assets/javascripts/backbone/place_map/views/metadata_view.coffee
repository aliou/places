class App.Views.MetadataView extends Backbone.Marionette.ItemView
  el: '#metadata'
  template: false

  ui:
    'edit': '#edit'

  events:
    'click @ui.edit': 'edit'

  initialize: (options) =>
    @model = options.model

  # Public: Edit the current Place metadata.
  #
  # TODO: Open the edit modal.
  # Returns nothing.
  edit: (event) =>
