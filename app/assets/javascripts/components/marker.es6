class Marker extends React.Component {

  componentDidMount() {
    const layer = L.mapbox.featureLayer({
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [
          this.props.place.get('lng'), this.props.place.get('lat')
        ]
      },
      properties: {
        title: this.props.place.get('name'),
        description: this.props.place.get('address'),
      }
    });

    layer.addTo(this.props.map);
    this.setState({ layer: layer });
  }

  render() {
    return false;
  }
}

Marker.propTypes = {
  map:   React.PropTypes.object.isRequired,
  place: React.PropTypes.object.isRequired,
};
