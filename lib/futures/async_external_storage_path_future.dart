import 'dart:async';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../interfaces/i_async_process.dart';

class AsyncExternalPathFuture implements IAsyncProcess {
  CancelableOperation?
      _action; // Create a CancelableOperation variable to manage cancellation.

  static const platform = MethodChannel('com.example.myapp/channel');

  bool _isActive = false;
  bool _actionCompleted = false;

  AsyncExternalPathFuture();

  @override
  void start(VoidCallbackParameter? failed, VoidCallbackParameter? success) {
    _isActive = true;
    _actionCompleted = false;
    _process(success, failed);
  }

  Future<void> _process(VoidCallbackParameter? success, VoidCallbackParameter? failed) async {
    try {
      _action = CancelableOperation.fromFuture(
        platform.invokeMethod('getPublicDocumentsFolder'),
      ).then((path) {
        // Handle completion
        debugPrint("******* Handle completion *******");
        if (path != null && path is String) {
          debugPrint("Ok->$path");
          success?.call(path);
         }
        else {
          debugPrint("Failed");
          failed?.call('Failed to get path');
        }
      });

      if (!_action!.isCanceled) {
        _actionCompleted = true;
        debugPrint("******* Completed *******");
      }
    } on PlatformException catch (exception) {
      debugPrint("******* PlatformException ${exception.toString()} *******");
      failed?.call("PlatformException ${exception.toString()}");
    } catch (exception) {
      // Handle exception
      debugPrint("******* exception ${exception.toString()} *******");
      failed?.call("Exception ${exception.toString()}");
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
