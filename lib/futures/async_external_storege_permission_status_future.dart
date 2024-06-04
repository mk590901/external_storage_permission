import 'dart:async';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import '../interfaces/i_async_process.dart';

class AsyncPermissionStatusFuture implements IAsyncProcess {
  CancelableOperation?
      _action; // Create a CancelableOperation variable to manage cancellation.

  bool _isActive = false;
  bool _actionCompleted = false;
  
  AsyncPermissionStatusFuture();

  @override
  void start(VoidCallback? failed, [VoidCallback? success]) {
    _isActive = true;
    _actionCompleted = false;
    _process(success, failed);
  }

  Future<void> _process(VoidCallback? success, VoidCallback? failed) async {
    try {
      // Simulate a time-consuming download operation.
      _action = CancelableOperation.fromFuture(
        Permission.manageExternalStorage.status,
      ).then((status) {
        // Handle completion
        debugPrint("******* Handle completion *******");
        if (!status.isGranted) {
          failed?.call();
        }
        else {
          success?.call();
        }
      });

      if (!_action!.isCanceled) {
        _actionCompleted = true;
        debugPrint("******* Completed *******");
      }
    } catch (exception) {
      // Handle exception
      debugPrint("******* exception *******");
      failed?.call();
    } finally {
      _isActive = false;
      debugPrint("******* finally *******");
    }
  }

  @override
  void stop(VoidCallback? cancel) {
    if (_action != null && !_action!.isCanceled) {
      _action!.cancel(); // Cancel the process if it's running.
      _isActive = false;
      debugPrint("******* cancel *******");
      cancel?.call();
    }
  }
}