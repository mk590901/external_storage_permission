import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import '../interfaces/i_async_process.dart';
import 'basic_async_process.dart';

class AsyncFilesFuture extends AsyncProcess {
  @override
  Future<void> process(VoidCallbackParameter? success, VoidCallbackParameter? failed) async {
    String path = "/storage/emulated/0/Download";
    try {
      action = CancelableOperation.fromFuture(
          Directory(path).list(recursive: true, followLinks: false).toList()
      ).then((entities) {
        // Handle completion
        debugPrint("******* AsyncFilesFuture.Handle completion *******");
        if (entities != null) {
          //debugPrint("AsyncFilesFuture.Ok->$entities");

          for (FileSystemEntity element in entities) {
            if (element is File) {
              print('File  : ${element.path}');
            }
            else
            if (element is Directory) {
              print('Folder: ${element.path}');
            }
          }
          success?.call(/*entities.toString()*/"Ok");
         }
        else {
          debugPrint("AsyncFilesFuture.Failed");
          failed?.call("Is NULL");
        }
      });

      if (!action!.isCanceled) {
        actionCompleted = true;
        debugPrint("******* AsyncFilesFuture.Completed *******");
      }
    } catch (exception) {
      // Handle exception
      debugPrint("******* AsyncFilesFuture.exception ${exception.toString()} *******");
      failed?.call("Exception ${exception.toString()}");
    } finally {
      isActive = false;
      debugPrint("AsyncFilesFuture.******* finally *******");
    }
  }


}
