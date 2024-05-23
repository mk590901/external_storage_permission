import 'package:flutter/material.dart';
import 'dart:io';
//import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const CheckPermissionApp());
}

class CheckPermissionApp extends StatelessWidget {
  const CheckPermissionApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Check Permission',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {

  final permissionExternalStorage = Permission.manageExternalStorage;

  const HomePage({super.key});

  void externalStoragePermissionStatus() async {
    // Request location permission
    final status = await permissionExternalStorage.request();
    if (status == PermissionStatus.granted) {
      // Get the current location
      print('Location permission granted.');
    } else {
      // Permission denied
      print('Location permission denied.');
    }
  }

  // void test() async {
  //   List<Directory>? directories;
  //   try {
  //     directories = await getExternalStorageDirectories();
  //   } catch (e) {
  //     print("Could not get external storage directories: $e");
  //   }
  //
  //   if (directories != null) {
  //     for (Directory directory in directories) {
  //       print('File  : ${directory.path}');
  //     }
  //   }
  // }

  void filesList() async {
    print('Files list');
    //Directory? downloadsDirectory = await getExternalStorageDirectory();
    // String? path = downloadsDirectory?.path;
    String path = "/storage/emulated/0/Download";
    print ('PATH->$path');
    final directory = Directory(path);
    if (await directory.exists()) {
      print ('PATH->$path exist');
      final List<FileSystemEntity> entities = directory.listSync(recursive: true, followLinks: false);
      for (FileSystemEntity element in entities) {
        if (element is File) {
          print('File  : ${element.path}');
        }
        else
        if (element is Directory) {
          print('Folder: ${element.path}');
        }
      }
    }
  }

  Future<void> requestFilesList(final String text) async {
    print("requestFilesList->$text");
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();
    }
    if (status.isGranted) {
      //_listFiles();
      print ("Permission granted");
    }
    else {
      print ("Permission denied");
      // setState(() {
      //   _files = ['Permission denied'];
      // });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Permission Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: externalStoragePermissionStatus,
              child: const Text('Check permission'),
            ),

            ElevatedButton(
              onPressed: filesList,//filesList,
              child: const Text('Files list'),
            ),

            ElevatedButton(
              onPressed: () { requestFilesList("Downloads"); }, //filesList,
              child: const Text('Get Files List'),
            ),

          ],
        ),
      ),
    );
  }
}
