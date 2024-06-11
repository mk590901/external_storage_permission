
//  Button events
import '../../core/event.dart';

class Reset<T> extends Event<T> {
  T? _data;

  Reset();

  Reset.ext(this._data);

  @override
  T? getData() {
    return _data;
  }

  @override
  Reset<T> setData([T? data]) {
    _data = data;
    return this;
  }
}

class Click<T> extends Event<T> {
  T? _data;

  Click([this._data]);

  @override
  T? getData() {
    return _data;
  }

  @override
  Click<T> setData([T? data]) {
    _data = data;
    return this;
  }
}

class Down<T> extends Event<T> {
  T? _data;

  Down([this._data]);

  @override
  T? getData() {
    return _data;
  }

  @override
  Down<T> setData([T? data]) {
    _data = data;
    return this;
  }
}

class Up<T> extends Event<T> {
  T? _data;

  Up([this._data]);

  @override
  T? getData() {
    return _data;
  }

  @override
  Up<T> setData([T? data]) {
    _data = data;
    return this;
  }
}

class Enable<T> extends Event<T> {
  T? _data;

  Enable([this._data]);

  @override
  T? getData() {
    return _data;
  }

  @override
  Enable<T> setData([T? data]) {
    _data = data;
    return this;
  }
}

class Disable<T> extends Event<T> {
  T? _data;

  Disable([this._data]);

  @override
  T? getData() {
    return _data;
  }

  @override
  Disable<T> setData([T? data]) {
    _data = data;
    return this;
  }
}
