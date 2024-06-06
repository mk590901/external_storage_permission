import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/event.dart';
import '../core/basic_state_machine.dart';
import '../state_machines/access_state_machine.dart';
import '../blocs/access_state.dart';
import 'access_events.dart';

class AccessBloc extends Bloc<Event, AccessState> {
  BasicStateMachine? _stateMachine;

  AccessBloc(AccessState initialState) : super(initialState) {
    _stateMachine = AccessStateMachine(initialState.state().index);
    on<CheckPermission>((event, emit) {
      done(event, emit);
    });
    on<Allow>((event, emit) {
      done(event, emit);
    });
    on<Dismiss>((event, emit) {
      done(event, emit);
    });
    on<Failed>((event, emit) {
      done(event, emit);
    });
    on<Success>((event, emit) {
      done(event, emit);
    });
    on<Cancel>((event, emit) {
      done(event, emit);
    });
    on<Granted>((event, emit) {
      done(event, emit);
    });
    on<NoGranted>((event, emit) {
      done(event, emit);
    });
  }

  void done(Event event, Emitter<AccessState> emit) {
    int newState = _stateMachine!.dispatch(event);
    if (newState >= 0) {
      AccessState nextState = AccessState(AccessStates.values[newState]);
      nextState.setData(event.getData());
      emit(nextState);
    }
  }
}
