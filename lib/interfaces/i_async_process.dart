import 'dart:ui';

abstract class IAsyncProcess {
  void start(VoidCallback? success, VoidCallback? failed);
  void stop(VoidCallback? cancel);
}