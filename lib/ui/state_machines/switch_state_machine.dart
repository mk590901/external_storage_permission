import '../../core/basic_state_machine.dart';
import '../../core/event.dart';
import '../../core/state.dart';
import '../../core/trans.dart';
import '../events/switch_events.dart';
import '../states/switch_state.dart';
import 'trans_methods.dart';

class SwitchStateMachine extends BasicStateMachine {
  SwitchStateMachine(super.currentState);

  @override
  void create() {
    states_[SwitchState.state_(SwitchStates.off)] = State([
      Trans(Disable(),  SwitchState.state_(SwitchStates.disabled_off), OnNothing()),
      Trans(Reset(),    SwitchState.state_(SwitchStates.off), OnNothing()),
      Trans(Click(),    SwitchState.state_(SwitchStates.on), OnNothing())
    ]);

    states_[SwitchState.state_(SwitchStates.on)] = State([
      Trans(Disable(),  SwitchState.state_(SwitchStates.disabled_on), OnNothing()),
      Trans(Reset(),    SwitchState.state_(SwitchStates.on),  OnNothing()),
      Trans(Click(),    SwitchState.state_(SwitchStates.off), OnNothing())
    ]);

    states_[SwitchState.state_(SwitchStates.disabled_off)] = State([
      Trans(Enable(),   SwitchState.state_(SwitchStates.off), OnNothing()),
    ]);

    states_[SwitchState.state_(SwitchStates.disabled_on)] = State([
      Trans(Enable(),   SwitchState.state_(SwitchStates.on), OnNothing()),
    ]);

  }

  @override
  String? getEventName(int event) {
    // TODO: implement getEventName
    throw UnimplementedError();
  }

  @override
  String? getStateName(int state) {
    String result = SwitchStates.values[state].name;
    return result;
  }

  @override
  void publishEvent(Event event) {
    // TODO: implement publishEvent
  }

  @override
  void publishState(int state) {
    // TODO: implement publishState
  }
}
