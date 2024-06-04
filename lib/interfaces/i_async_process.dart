import 'dart:ui';

abstract class IAsyncProcess {
  void start(VoidCallback? failed, VoidCallback? success);
  void stop(VoidCallback? cancel);
}