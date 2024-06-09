// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:external_storage_permission/blocs/access_events.dart';
import 'package:external_storage_permission/blocs/access_state.dart';
import 'package:external_storage_permission/core/basic_state_machine.dart';
import 'package:external_storage_permission/state_machines/access_state_machine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TaskStateMachine', () {
    BasicStateMachine? stateMachine =
      AccessStateMachine(AccessState.state_(AccessStates.idle));
    expect(stateMachine.state(),  AccessState.state_(AccessStates.idle));
    stateMachine.dispatch(CheckPermission());
    expect(stateMachine.state(),  AccessState.state_(AccessStates.status));
    stateMachine.dispatch(NoGranted());
    expect(stateMachine.state(),  AccessState.state_(AccessStates.ask));
    stateMachine.dispatch(Allow());
    expect(stateMachine.state(),  AccessState.state_(AccessStates.request));
    stateMachine.dispatch(Granted());
    expect(stateMachine.state(),  AccessState.state_(AccessStates.path));
    stateMachine.dispatch(Success());
    expect(stateMachine.state(),  AccessState.state_(AccessStates.exist));
    stateMachine.dispatch(Success());
    expect(stateMachine.state(),  AccessState.state_(AccessStates.files));
    stateMachine.dispatch(Success());
    expect(stateMachine.state(),  AccessState.state_(AccessStates.rendering));
    stateMachine.dispatch(Success());
    expect(stateMachine.state(),  AccessState.state_(AccessStates.idle));

    stateMachine.dispatch(CheckPermission());
    expect(stateMachine.state(),  AccessState.state_(AccessStates.status));
    stateMachine.dispatch(Granted());
    expect(stateMachine.state(),  AccessState.state_(AccessStates.path));
    stateMachine.dispatch(Failed());
    expect(stateMachine.state(),  AccessState.state_(AccessStates.idle));

    stateMachine.dispatch(CheckPermission());
    expect(stateMachine.state(),  AccessState.state_(AccessStates.status));
    stateMachine.dispatch(Granted());
    expect(stateMachine.state(),  AccessState.state_(AccessStates.path));
    stateMachine.dispatch(Success());
    expect(stateMachine.state(),  AccessState.state_(AccessStates.exist));
    stateMachine.dispatch(Failed());
    expect(stateMachine.state(),  AccessState.state_(AccessStates.idle));

  });
}
