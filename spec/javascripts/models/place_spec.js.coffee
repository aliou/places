#= require spec_helper

# TODO: Create fixtures.
describe 'App.Models.Place', ->
  beforeEach (done) ->
    @slug = 'tour-eiffel'
    done()

  describe '#slug', ->
    it 'sets the slug when given', ->
      subject = new App.Models.Place(@slug)

      expect(subject.get('slug')).to.eq(@slug)

  describe '#toFeatureLayer', ->
    beforeEach (done) ->
      @subject = new App.Models.Place(@slug)
      done()

    it 'fetches the full model before the convertion', ->
      expect(@subject.get('lng')).to.eq('2.29442596435547')

    it 'returns a featureLayer', ->
      featureLayer = @subject.toFeatureLayer()

      expect(featureLayer.type).to.eq('Feature')
