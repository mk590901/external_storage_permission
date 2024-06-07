enum AccessStates {
  idle,
  status,
  ask,
  request,
  path,
  exist,  //  path
  files
}

class AccessState<T> {

  static int state_(AccessStates state) {
    return state.index;
  }

  final AccessStates _state;
  T? _data;

  AccessState(this._state) {
    _data = null;
  }

  AccessStates state() {
    return _state;
  }
  
  void setData(T? data) {
    _data = data;
  }

  T? data() {
    return _data;
  }
}
