import 'dart:async';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../interfaces/i_async_process.dart';
import 'basic_async_process.dart';

class AsyncExternalPathFuture extends AsyncProcess {

  static const platform = MethodChannel('com.flutter.io/channel');

  @override
  void setParameter(final dynamic parameter) {}

  @override
  Future<void> process(VoidCallbackParameter? success, VoidCallbackParameter? failed) async {
    try {
      action = CancelableOperation.fromFuture(
        platform.invokeMethod('getPublicDocumentsFolder'),
        //platform.invokeMethod('getPublicDownloadsFolder'),
      ).then((path) {
        // Handle completion
        debugPrint("******* AsyncExternalPathFuture.Handle completion *******");
        if (path != null && path is String) {
          debugPrint("AsyncExternalPathFuture.Ok->$path");
          success?.call(path);
         }
        else {
          debugPrint("AsyncExternalPathFuture.Failed");
          failed?.call('Failed to get path');
        }
      });

      if (!action!.isCanceled) {
        actionCompleted = true;
        debugPrint("******* AsyncExternalPathFuture.Completed *******");
      }
    } on PlatformException catch (exception) {
      debugPrint("******* AsyncExternalPathFuture.PlatformException ${exception.toString()} *******");
      failed?.call("PlatformException ${exception.toString()}");
    } catch (exception) {
      // Handle exception
      debugPrint("******* AsyncExternalPathFuture.exception ${exception.toString()} *******");
      failed?.call("Exception ${exception.toString()}");
    } finally {
      isActive = false;
      debugPrint("AsyncExternalPathFuture.******* finally *******");
    }
  }


}
