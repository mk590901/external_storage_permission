import 'dart:ui';

typedef VoidCallbackParameter = void Function(dynamic parameter);

abstract class IAsyncProcess {
  void start(VoidCallbackParameter? failed, VoidCallbackParameter? success);
  void stop(VoidCallback? cancel);
}