enum SwitchStates { off, on, disabled_off, disabled_on }

class SwitchState {
  static int state_(SwitchStates state) {
    return state.index;
  }

  final SwitchStates _state;
  String? _data;

  SwitchState(this._state) {
    _data = null;
  }

  SwitchStates state() {
    return _state;
  }

  void setData(String? data) {
    _data = data;
  }

  String? data() {
    return _data;
  }
}
