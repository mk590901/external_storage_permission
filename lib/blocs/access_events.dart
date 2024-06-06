import '../core/event.dart';

//  Button events
class CheckPermission<T> extends Event<T> {
  T? _data;
  CheckPermission([this._data]);
  @override
  T? getData() {
    return _data;
  }
  @override
  CheckPermission<T> setData([T? data]) {
    _data = data;
    return this;
  }
}

class Allow<T> extends Event<T> {
  T? _data;
  Allow([this._data]);
  @override
  T? getData() {
    return _data;
  }
  @override
  Allow<T> setData([T? data]) {
    _data = data;
    return this;
  }
}

class Dismiss<T> extends Event<T> {
  T? _data;
  Dismiss([this._data]);
  @override
  T? getData() {
    return _data;
  }
  @override
  Dismiss<T> setData([T? data]) {
    _data = data;
    return this;
  }
}

class Success<T> extends Event<T> {
  T? _data;
  Success([this._data]);
  @override
  T? getData() {
    return _data;
  }
  @override
  Success<T> setData([T? data]) {
    _data = data;
    return this;
  }
}

class Cancel<T> extends Event<T> {
  T? _data;
  Cancel([this._data]);
  @override
  T? getData() {
    return _data;
  }
  @override
  Cancel<T> setData([T? data]) {
    _data = data;
    return this;
  }
}

class Failed<T> extends Event<T> {
  T? _data;
  Failed([this._data]);
  @override
  T? getData() {
    return _data;
  }
  @override
  Failed<T> setData([T? data]) {
    _data = data;
    return this;
  }
}

class Granted<T> extends Event<T> {
  T? _data;
  Granted([this._data]);
  @override
  T? getData() {
    return _data;
  }
  @override
  Granted<T> setData([T? data]) {
    _data = data;
    return this;
  }
}

class NoGranted<T> extends Event<T> {
  T? _data;
  NoGranted([this._data]);
  @override
  T? getData() {
    return _data;
  }
  @override
  NoGranted<T> setData([T? data]) {
    _data = data;
    return this;
  }
}



