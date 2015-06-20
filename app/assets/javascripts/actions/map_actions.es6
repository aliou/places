const MapActions = {
  initialFetch: function initialFetch (data) {
    PlaceDispatcher.dispatch({
      actionType: ActionTypes.INITIAL_FETCH,
      data: data
    });
  }
};
