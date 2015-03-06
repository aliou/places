#= require spec_helper

describe 'App.Collections.Places', ->
  beforeEach (done) ->
    @slug = 'tour-eiffel'
    done()

  describe '#bySlug', ->
    it 'returns the Place with the given slug', ->
      place = new App.Models.Place(@slug)

      subject = new App.Collections.Places
      subject.fetch()

      expect(subject.bySlug(@slug)).to.eq(place)
