import 'dart:async';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import '../interfaces/i_async_process.dart';
import 'basic_async_process.dart';

class AsyncPermissionStatusFuture extends AsyncProcess {

  @override
  Future<void> process(VoidCallbackParameter? success, VoidCallbackParameter? failed) async {
    try {
      // Simulate a time-consuming download operation.
      action = CancelableOperation.fromFuture(
        Permission.manageExternalStorage.status,
      ).then((status) {
        // Handle completion
        debugPrint("******* AsyncPermissionStatusFuture.Handle completion *******");
        if (!status.isGranted) {
          failed?.call("No Granted");
        }
        else {
          success?.call("Granted");
        }
      });

      if (!action!.isCanceled) {
        actionCompleted = true;
        debugPrint("******* AsyncPermissionStatusFuture.Completed *******");
      }
    } catch (exception) {
      // Handle exception
      debugPrint("******* AsyncPermissionStatusFuture.exception *******");
      failed?.call("Exception ${exception.toString()}");
    } finally {
      isActive = false;
      debugPrint("******* AsyncPermissionStatusFuture.finally *******");
    }
  }
}
