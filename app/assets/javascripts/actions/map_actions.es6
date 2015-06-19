const MapActions = {
  initialFetch: function initialFetch () {
    PlaceDispatcher.dispatch({
      actionType: ActionTypes.INITIAL_FETCH
    });
  }
};
