import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
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
      home: BlocProvider(
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

  late List<String> items = [];

  HomePage({super.key});

  void processRequestPermission(final AccessBloc accessBloc) async {
    permissionRequestFuture.start((text) {
      debugPrint('permissionRequestFuture.Failed: $text');
      accessBloc.add(Dismiss());
    }, (text) {
      debugPrint('permissionRequestFuture.Success: $text');
      accessBloc.add(Allow(
          //  Request path
          () {
        processGrantedPermission(accessBloc);
      }));
    });
  }

  void processGrantedPermission(AccessBloc accessBloc) {
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
              }, //  Failed
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
                        items.clear();
                        for (FileSystemEntity element in entries) {
                          if (element is File) {
                            //debugPrint('F: ${element.path}');
                            items.add('F: ${element.path}');
                          } else if (element is Directory) {
                            //debugPrint('D: ${element.path}');
                            items.add('D: ${element.path}');
                          }
                        }
                      } else {
                        debugPrint('!Success!$entries');
                      }
                      accessBloc.add(Success());
                    },
                  );
                }));
              }, //  Success
            );
          }));
        },
      );
    }));
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
            }, //  Failed
            (text) {
              debugPrint('CheckPermission.Success');
              processGrantedPermission(accessBloc);
            }, //  Success
          );
        });
      } else if (state == AccessStates.status) {
        debugPrint('state->$state');
      } else if (state == AccessStates.rendering) {
        debugPrint('state->$state');
        return Success();
      }
      return Cancel();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Public External Storage Content',
            style: buildTitleTextStyle()),
        leading: IconButton(
          icon: const Icon(Icons.security_sharp, color: Colors.white),
          // Icon widget
          onPressed: () {
            // Add your onPressed logic here
          },
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: BlocBuilder<AccessBloc, AccessState>(
        builder: (context, state) {
          if (state.state() == AccessStates.rendering) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: buildListWithDividers(items),
              ),
            );
          } else if (state.state() == AccessStates.ask) {
            debugPrint('MATERIAL BANNER');
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
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  leading: const Icon(Icons.warning_amber,
                      size: 32, color: Colors.blueGrey),
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
                        processRequestPermission(accessBloc);
                      },
                      child: const Text('GET ACCESS'),
                    ),
                  ],
                ),
              ),
            );
          } else if (state.state() == AccessStates.files) {
            return Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const SizedBox(
                    width: 256.0,
                    height: 256.0,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                      strokeWidth: 16,
                    ),
                  ),
                  Text(
                    'Task in progress...\nPlease wait',
                    textAlign: TextAlign.center,
                    style: buildTextStyle(),
                  ),
                ],
              ),
            );
          } else {
            return Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'State: ${state.state()}',
                        style: buildTextStyle(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton:
          BlocBuilder<AccessBloc, AccessState>(builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                onPressed: () {
                  accessBloc.add(getEvent(state.state()));
                },
                backgroundColor: Colors.blue,
                child: Icon(
                  getIcon(state.state()),
                  size: 32,
                  color: Colors.white,
                )),
          ],
        );
      }),
    );
  }

  TextStyle buildTitleTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontStyle: FontStyle.italic,
      shadows: [
        Shadow(
          blurRadius: 8.0,
          color: Colors.indigo,
          offset: Offset(3.0, 3.0),
        ),
      ],
    );
  }

  TextStyle buildTextStyle() {
    return const TextStyle(
      color: Colors.lightBlue,
      fontSize: 18,
      fontStyle: FontStyle.normal,
      shadows: [
        Shadow(
          blurRadius: 4.0,
          color: Colors.black12,
          offset: Offset(2.0, 2.0),
        ),
      ],
    );
  }

  IconData? getIcon(AccessStates state) {
    return (state == AccessStates.rendering)
        ? Icons.refresh_sharp
        : Icons.folder_outlined;
  }

  List<Widget> buildListWithDividers(List<String> items) {
    List<Widget> widgets = [];
    for (int i = 0; i < items.length; i++) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 1),
          child: Text(items[i], style: const TextStyle(fontSize: 12)),
        ),
      );
      // Add a Divider after every item except the last one
      if (i < items.length - 1) {
        widgets.add(const Divider());
      }
    }
    return widgets;
  }
}
