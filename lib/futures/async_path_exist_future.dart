import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../interfaces/i_async_process.dart';
import 'basic_async_process.dart';

class AsyncPathExistFuture extends AsyncProcess {

  late String _path;

  @override
  void setParameter(final dynamic path) {
    _path = path;
  }

  @override
  Future<void> process(VoidCallbackParameter? success, VoidCallbackParameter? failed) async {
    //@String path = "/storage/emulated/0/Download";
    String path = _path;
    try {
      action = CancelableOperation.fromFuture(
          Directory(path).exists()
      ).then((exist) {
        // Handle completion
        debugPrint("******* AsyncExternalPathFuture.Handle completion *******");
        if (exist) {
          debugPrint("AsyncPathExistFuture.Ok->$path");
          success?.call(exist.toString());
         }
        else {
          debugPrint("AsyncPathExistFuture.Failed");
          failed?.call(exist.toString());
        }
      });

      if (!action!.isCanceled) {
        actionCompleted = true;
        debugPrint("******* AsyncPathExistFuture.Completed *******");
      }
    } catch (exception) {
      // Handle exception
      debugPrint("******* AsyncPathExistFuture.exception ${exception.toString()} *******");
      failed?.call("Exception ${exception.toString()}");
    } finally {
      isActive = false;
      debugPrint("AsyncPathExistFuture.******* finally *******");
    }
  }


}
