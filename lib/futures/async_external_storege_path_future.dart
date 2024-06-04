import 'dart:async';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../interfaces/i_async_process.dart';

class AsyncExternalPathFuture implements IAsyncProcess {
  CancelableOperation?
      _action; // Create a CancelableOperation variable to manage cancellation.

  static const platform = MethodChannel('com.example.myapp/channel');

  bool _isActive = false;
  bool _actionCompleted = false;

  AsyncExternalPathFuture();

//  void greet({String name = 'Guest', int age = 18})

  @override
  void start(VoidCallback? failed, [VoidCallback? success, void Function(String)? aux]) {
    _isActive = true;
    _actionCompleted = false;
    _process(success, failed, aux);
  }

  Future<void> _process(VoidCallback? success, VoidCallback? failed, [void Function(String)? aux]) async {
    try {
      _action = CancelableOperation.fromFuture(
        platform.invokeMethod('getPublicDocumentsFolder'),
      ).then((path) {
        // Handle completion
        debugPrint("******* Handle completion *******");
        if (path != null && path is String) {
          debugPrint("Ok->$path");
          success?.call();
          aux?.call(path);
        }
        else {
          debugPrint("Failed");
          failed?.call();
        }
      });

      if (!_action!.isCanceled) {
        _actionCompleted = true;
        debugPrint("******* Completed *******");
      }
    } on PlatformException catch (exception) {
      debugPrint("******* PlatformException ${exception.toString()} *******");
      failed?.call();
    } catch (exception) {
      // Handle exception
      debugPrint("******* exception ${exception.toString()} *******");
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
