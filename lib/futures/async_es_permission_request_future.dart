import 'dart:async';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import '../interfaces/i_async_process.dart';
import 'basic_async_process.dart';

class AsyncPermissionRequestFuture extends AsyncProcess {

  @override
  void setParameter(final dynamic parameter) {}

  @override
  Future<void> process(VoidCallbackParameter? success, VoidCallbackParameter? failed) async {
    try {
      // Simulate a time-consuming download operation.
      action = CancelableOperation.fromFuture(
        Permission.manageExternalStorage.request(),
      ).then((status) {
        // Handle completion
        debugPrint("******* AsyncPermissionRequestFuture.Handle completion *******");
        if (!status.isGranted) {
          failed?.call("No Granted");
        }
        else {
          success?.call("Is Granted");
        }
      });

      if (!action!.isCanceled) {
        actionCompleted = true;
        debugPrint("******* AsyncPermissionRequestFuture.Completed *******");
      }
    } catch (exception) {
      // Handle exception
      debugPrint("******* AsyncPermissionRequestFuture.exception *******");
      failed?.call("Exception ${exception.toString()}");
    } finally {
      isActive = false;
      debugPrint("******* AsyncPermissionRequestFuture.finally *******");
    }
  }
}
