var Map = React.createClass({

  propTypes: {
    accessToken:   React.PropTypes.string.isRequired,
    mapId:         React.PropTypes.string.isRequired,
    initialCenter: React.PropTypes.array.isRequired,
    initialZoom:   React.PropTypes.number
  },

  componentDidMount: function componentDidMount () {
    L.mapbox.accessToken = this.props.accessToken;
    var options = { zoomControl: false, attributionControl: false };
    var map = L.mapbox.map('map', this.props.mapId, options);

    map.setView(this.props.initialCenter, this.props.initialZoom);
    new L.Control.Zoom({ position: 'bottomright' }).addTo(map);
  },

  render: function render () {
    return (
      <div id='map' className='absolute top-0 bottom-0 full-width'></div>
    );
  }
});
