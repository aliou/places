var Map = React.createClass({

  propTypes: {
    accessToken:   React.PropTypes.string.isRequired,
    mapId:         React.PropTypes.string.isRequired,
    initialCenter: React.PropTypes.array,
    initialZoom:   React.PropTypes.number
  },

  getDefaultProps: function getDefaultProps () {
    // Zoom on the center of paris on a neighborhood level by default.
    return {
      initialCenter: [48.85, 2.35],
      initialZoom: 16
    };
  },

  componentDidMount: function componentDidMount () {
    L.mapbox.accessToken = this.props.accessToken;
    var options = { attributionControl: false };
    var map = L.mapbox.map('map', this.props.mapId, options);

    map.setView(this.props.initialCenter, this.props.initialZoom);
  },

  render: function render () {
    return (
      <div id='map' className='absolute top-0 bottom-0 full-width'></div>
    );
  }
});
