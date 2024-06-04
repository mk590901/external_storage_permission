import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'dart:async';
import 'banner_bloc.dart';
import 'banner_events.dart';
import 'banner_states.dart';
import 'futures/async_external_storege_path_future.dart';
import 'futures/async_external_storege_permission_future.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: //const HomePage(),
      BlocProvider(
        create: (context) => BannerBloc(),
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {

  final AsyncPermissionFuture permissionFuture = AsyncPermissionFuture();
  final AsyncExternalPathFuture pathFuture = AsyncExternalPathFuture();

  final permissionExternalStorage = Permission.manageExternalStorage;

  static const platform = MethodChannel('com.example.myapp/channel');

  HomePage({super.key});

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


  void requestPermission(final BuildContext context) async {
    PermissionStatus status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      if (context.mounted) {
        context.read<BannerBloc>().add(HideBanner());
      }
    }
  }

  // Future<void> requestFilesList(final BuildContext context, final String text) async {
  //   print("requestFilesList->$text");
  //
  //   // context.read<BannerBloc>().add(ShowBanner());
  //
  //   PermissionStatus status = await Permission.manageExternalStorage.status;
  //   if (!status.isGranted) {
  //     //  Show banner
  //     //@status = await Permission.manageExternalStorage.request();
  //     if (context.mounted) {
  //       context.read<BannerBloc>().add(ShowBanner());
  //     }
  //   }
  //
  //   if (status.isGranted) {
  //     //_listFiles();
  //     String folder = await _getBatteryLevel();
  //     print ("Permission granted->$folder");
  //   }
  //   else {
  //     print ("Permission denied");
  //   }
  // }

  Future<void> requestFilesList(final BannerBloc bloc, final String text) async {
    print("requestFilesList->$text");

    // context.read<BannerBloc>().add(ShowBanner());

    PermissionStatus status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      //  Show banner
      //@status = await Permission.manageExternalStorage.request();
        bloc.add(ShowBanner());
     }

    if (status.isGranted) {
      //_listFiles();
      String folder = await getExternalStoragePath();
      print ("Permission granted->$folder");
    }
    else {
      print ("Permission denied");
    }
  }

  Future<String> getExternalStoragePath() async {
    String output;
    try {
      final String result = await platform.invokeMethod('getPublicDocumentsFolder');
      output = 'getExternalStoragePath-> $result.';
    } on PlatformException catch (e) {
      output = "Failed getExternalStoragePath: '${e.message}'.";
    }
    print(output); // You can also update the UI with this value
    return output;
  }

  @override
  Widget build(BuildContext context) {

    final bannerBloc = BlocProvider.of<BannerBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Banner with BLoC'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Your main content here'),
                ElevatedButton(
                  onPressed: () {
                    permissionFuture.start(
                          () {
                            bannerBloc.add(ShowBanner());
                          },  //  Failed
                          () {
                            print ("******* Permission OK *******");
                            //getExternalStoragePath();
                            pathFuture.start(
                                () { print('!Failed!'); },
                                null,//() { print('!Success!'); },
                                (text) { print('!Aux!$text'); },
                            );
                      },  //  Ok
                    );
                  },
                  child: const Text('Get Files List'),
                ),
              ],
            ),
          ),
          BlocBuilder<BannerBloc, BannerState>(
            builder: (context, state) {
              if (state is BannerVisible) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: MaterialBanner(
                      content: const Text(
                        'To read and save data, you must allow the application access to the public folders of device.',
                        style: TextStyle(color: Colors.blueGrey),),
                      leading: const Icon(Icons.warning_amber, size: 32, color: Colors.blueGrey),
                      backgroundColor: Colors.grey[350],
                      actions: [
                        TextButton(
                          onPressed: () {
                            context.read<BannerBloc>().add(HideBanner());
                          },
                          child: const Text('DISMISS'),
                        ),
                        TextButton(
                          onPressed: () {
                            requestPermission(context);
                          },
                          child: const Text('GET ACCESS'),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink(); // An empty widget
              }
            },
          ),
        ],
      ),
    );
  }


/*
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
            // ElevatedButton(
            //   onPressed: externalStoragePermissionStatus,
            //   child: const Text('Check permission'),
            // ),
            //
            // ElevatedButton(
            //   onPressed: filesList,//filesList,
            //   child: const Text('Files list'),
            // ),

            ElevatedButton(
              onPressed: () { requestFilesList("Downloads"); }, //filesList,
              child: const Text('Get Files List'),
            ),

          ],
        ),
      ),
    );
  }
   */
}
