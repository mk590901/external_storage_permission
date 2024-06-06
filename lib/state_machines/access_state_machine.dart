import '../core/basic_state_machine.dart';
import '../core/state.dart';
import '../core/trans.dart';
import '../core/event.dart';
import '../blocs/access_state.dart';
import '../blocs/access_events.dart';
import 'trans_methods.dart';

class AccessStateMachine extends BasicStateMachine {
  AccessStateMachine(super.currentState);

  @override
  void create() {
    states_ [AccessState.state_(AccessStates.idle)]   = State([ Trans(CheckPermission(),  AccessState.state_(AccessStates.status),  OnCheckPermission())]);
    states_ [AccessState.state_(AccessStates.status)] = State([ Trans(NoGranted(),        AccessState.state_(AccessStates.ask),     OnNoGranted()),
                                                                Trans(Granted(),          AccessState.state_(AccessStates.path),    OnGranted()),
                                                              ]);
    states_ [AccessState.state_(AccessStates.ask)]    = State([ Trans(Dismiss(),          AccessState.state_(AccessStates.idle),    OnDismiss()),
                                                                Trans(Allow(),            AccessState.state_(AccessStates.request), OnAllow()),
                                                              ]);
    states_ [AccessState.state_(AccessStates.request)]= State([ Trans(NoGranted(),        AccessState.state_(AccessStates.idle),    OnNoGranted()),
                                                                Trans(Granted(),          AccessState.state_(AccessStates.path),    OnGranted()),
                                                              ]);
    states_ [AccessState.state_(AccessStates.path)]   = State([ Trans(Failed(),           AccessState.state_(AccessStates.idle),    OnFailed()),
                                                                Trans(Success(),          AccessState.state_(AccessStates.files),   OnSuccess()),
                                                              ]);
    states_ [AccessState.state_(AccessStates.files)]  = State([ Trans(Failed(),           AccessState.state_(AccessStates.idle),    OnFailed()),
                                                                Trans(Success(),          AccessState.state_(AccessStates.idle),   OnSuccess()),
    ]);
  }

  @override
  String? getEventName(int event) {
    // TODO: implement getEventName
    throw UnimplementedError();
  }

  @override
  String? getStateName(int state) {
    return AccessStates.values[state].name;
  }

  @override
  void publishEvent(Event event) {
    print ("publishEvent->$event");
  }

  @override
  void publishState(int state) {
    // TODO: implement publishState
  }



}
