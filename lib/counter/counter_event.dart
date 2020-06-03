import 'package:meta/meta.dart';

import 'counter_state.dart';

@immutable
abstract class CounterEvent {}

/// lacking a first class way to explicitly cause a transition, this is just
/// a special event that lets me transition state more directly
class CounterStateTransitionEvent extends CounterEvent {
  final CounterState nextState;

  CounterStateTransitionEvent(this.nextState);
}
