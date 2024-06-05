import 'dart:ui';

typedef VoidCallbackParameter = void Function(String parameter);

abstract class IAsyncProcess {
  void start(VoidCallbackParameter? failed, VoidCallbackParameter? success);
  void stop(VoidCallback? cancel);
}