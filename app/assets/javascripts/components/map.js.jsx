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

  getInitialState: function getInitialState () {
    return { places: PlaceStore, map: null };
  },

  createMap: function createMap () {
    L.mapbox.accessToken = this.props.accessToken;
    var options = { attributionControl: false };
    var map = L.mapbox.map(this.getDOMNode(), this.props.mapId, options);

    map.setView(this.props.initialCenter, this.props.initialZoom);
    this.setState({ map: map });
    this.state.places.on('all', this.forceUpdateCallback);
  },

  componentDidMount: function componentDidMount () {
    if (!this.state.map) {
      this.createMap();
    }
  },

  componentWillUnmount: function componentWillUnmount () {
    this.state.places.off('all', this.forceUpdateCallback);
  },

  render: function render () {
    return (
      <div id='map' className='absolute top-0 bottom-0 full-width'></div>
    );
  },

  forceUpdateCallback: function forceUpdateCallback () {
    this.forceUpdate();
  },
});
