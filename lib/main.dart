import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'dart:async';
import 'banner_bloc.dart';
import 'banner_events.dart';
import 'banner_states.dart';
import 'blocs/access_bloc.dart';
import 'blocs/access_events.dart';
import 'blocs/access_state.dart';
import 'core/event.dart';
import 'futures/async_es_path_future.dart';
import 'futures/async_es_permission_request_future.dart';
import 'futures/async_es_permission_status_future.dart';
import 'futures/async_files_future.dart';
import 'futures/async_path_exist_future.dart';
import 'futures/basic_async_process.dart';

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
//        create: (context) => BannerBloc(),
        create: (context) => AccessBloc(AccessState(AccessStates.idle)),
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {

  final AsyncProcess permissionStatusFuture = AsyncPermissionStatusFuture();
  final AsyncProcess permissionRequestFuture = AsyncPermissionRequestFuture();
  final AsyncProcess pathFuture = AsyncExternalPathFuture();
  final AsyncProcess pathExistFuture = AsyncPathExistFuture();
  final AsyncProcess filesFuture = AsyncFilesFuture();

  final permissionExternalStorage = Permission.manageExternalStorage;

  //static const platform = MethodChannel('com.example.myapp/channel');

  late String? _path;

  HomePage({super.key});


  void setPath(final String path) {
    _path = path;
  }

  String? getPath() {
    return _path;
  }

 /*
 Future<void> wrapFutureBoolWithThen() {
  return someFutureBool().then((bool result) {
    // Handle the boolean result
    if (result) {
      // Do something if true
    } else {
      // Do something if false
    }
  });
}

Future<bool> someFutureBool() async {
  // Simulate a future returning a boolean
  await Future.delayed(Duration(seconds: 1));
  return true; // or false
}


Future<void> checkDirectoryWithThen(String path) {
  return Directory(path).exists().then((bool exists) {
    if (exists) {
      print('Directory exists.');
    } else {
      print('Directory does not exist.');
    }
  });
}

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
  */
  void requestPermission(final BannerBloc bloc) async {
    permissionRequestFuture.start(
        (text) {
          print('permissionRequestFuture.Failed: $text');
        },
        (text) {
          print('permissionRequestFuture.Success: $text');
          bloc.add(HideBanner());
        } );
  }

  void requestPermission2(final AccessBloc accessBloc) async {
    permissionRequestFuture.start(
            (text) {
          print('permissionRequestFuture.Failed: $text');
        },
            (text) {
          print('permissionRequestFuture.Success: $text');
          accessBloc.add(Allow());
        } );
  }

  @override
  Widget build(BuildContext context) {
    final accessBloc = BlocProvider.of<AccessBloc>(context);

    Event getEvent(AccessStates state) {
      if (state == AccessStates.idle) {
        return CheckPermission(() {
          permissionStatusFuture.start(
                (text) {
                  debugPrint('CheckPermission.Failed');
                  accessBloc.add(NoGranted());
                },  //  Failed
                (text) {
                  debugPrint('CheckPermission.Success');
                  accessBloc.add(Granted(() {
                  //  Request path -> get path name
                    pathFuture.start(
                          (text) {
                            debugPrint('!pathFuture.Failed !$text');
                            accessBloc.add(Failed());
                          },
                          (entries) {
                            debugPrint('!pathFuture.Success !$entries');
                            pathExistFuture.setParameter(entries);
                            filesFuture.setParameter(entries);
                            accessBloc.add(Success(() {
                              pathExistFuture.start(
                                  (text) {
                                    debugPrint('!pathExistFuture.Failed !$text');
                                    accessBloc.add(Failed());
                                  },  //  Failed
                                  (text) {
                                    debugPrint('!pathExistFuture.success !$text');
                                    accessBloc.add(Success(() {
                                        filesFuture.start(
                                          (text) {
                                            debugPrint('!Failed !$text');
                                            accessBloc.add(Failed());
                                          },
                                          (entries) {
                                            if (entries is List<FileSystemEntity>) {
                                              for (FileSystemEntity element in entries) {
                                                if (element is File) {
                                                  print('F: ${element.path}');
                                                }
                                                else
                                                if (element is Directory) {
                                                  print('D: ${element.path}');
                                                }
                                              }
                                            }
                                            else {
                                              print('!Success!$entries');
                                            }
                                            accessBloc.add(Success());
                                         },
                                      );
                                    }
                                    ));
                                  },  //  Success
                              );
                            }
                            ));
                          },
                    );
                  } ));
                },  //  Success
          );
        });
      }
      else
      if (state == AccessStates.status) {
        debugPrint('state->$state');
      }
      else
      if (state == AccessStates.rendering) {
        debugPrint('state->$state');
        return Success();
      }
      return Cancel();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Material Banner with BLoC')),
      body: BlocBuilder<AccessBloc, AccessState>(
        builder: (context, state) {
      if (state.state() == AccessStates.ask) {
        print ('MATERIAL BANNER');
        //return const SizedBox.shrink();

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
                    accessBloc.add(Dismiss());
                  },
                  child: const Text('DISMISS'),
                ),
                TextButton(
                  onPressed: () {
                    requestPermission2(accessBloc);
                  },
                  child: const Text('GET ACCESS'),
                ),
              ],
            ),
          ),
        );
      }
      else {
        return Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Context: ${state.state()}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      accessBloc.add(getEvent(state.state()));
                    },
                    child: Text(getText(state.state())),
                  ),
                ],
              ),
            ),
          ],
        );
        }
        },
      ),
    );
  }

  String getText(AccessStates state) {
    if (state == AccessStates.idle) {
      return 'Check permission';
    }
    else
    if (state == AccessStates.status) {
      return 'Check status';
    }
    else
    if (state == AccessStates.ask) {
      return 'Show banner';
    }
    else
    if (state == AccessStates.path) {
      return 'Get path name';
    }
    else
    if (state == AccessStates.exist) {
      return 'Check permission existence';
    }
    else
    if (state == AccessStates.files) {
      return 'Get files';
    }
    else
    if (state == AccessStates.rendering) {
      return 'Rendering';
    }

    return 'Unknown';
  }

/*
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
                    permissionStatusFuture.start(
                          (text) {
                            print ("permissionStatusFuture.Failed $text");
                            bannerBloc.add(ShowBanner());
                          },  //  Failed
                          (text) {
                            print ("permissionStatusFuture.Success $text");
                            pathFuture.start(
                                  (text) { print('!pathFuture.Failed !$text'); },
                                  (entries) { print('!pathFuture.Success !$entries');},
                            );

                                //@pathExistFuture.start(

                            //   filesFuture.start(
                            //     (text) { print('!Failed !$text'); },
                            //     (entries) {
                            //       if (entries is List<FileSystemEntity>) {
                            //         for (FileSystemEntity element in entries) {
                            //           if (element is File) {
                            //             print('F: ${element.path}');
                            //           }
                            //           else
                            //           if (element is Directory) {
                            //             print('D: ${element.path}');
                            //           }
                            //         }
                            //       }
                            //       else {
                            //         print('!Success!$entries');
                            //       }
                            //    },
                            // );

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
                            bannerBloc.add(HideBanner());
                          },
                          child: const Text('DISMISS'),
                        ),
                        TextButton(
                          onPressed: () {
                            requestPermission(bannerBloc);
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
*/
}
