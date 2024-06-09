import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import '../interfaces/i_async_process.dart';

abstract class AsyncProcess implements IAsyncProcess {
  CancelableOperation? action; // Create a CancelableOperation variable to manage cancellation.
  bool isActive = false;
  bool actionCompleted = false;

  @override
  void start(VoidCallbackParameter? failed, VoidCallbackParameter? success) {
    isActive = true;
    actionCompleted = false;
    process(success, failed);
  }

  @override
  void stop(VoidCallback? cancel) {
    if (action != null && !action!.isCanceled) {
      action!.cancel(); // Cancel the process if it's running.
      isActive = false;
      debugPrint("******* cancel *******");
      cancel?.call();
    }
  }

  void setParameter(final dynamic parameter);

  Future<void>  process(VoidCallbackParameter? success, VoidCallbackParameter? failed); //  abstract function


}