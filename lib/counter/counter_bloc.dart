import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_test_skip_issue/counter/bloc.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  @override
  CounterState get initialState => CounterState(0);


  CounterBloc() {
    // we could perhaps subscribe to a stream here still if we want, chain multiple blocs together, still works the same way.
  }

  @override
  /// essentially, we haven't found it useful to route everything through this
  /// function. This business logic component should be the place where business
  /// logic happens and we stick to that. But we haven't found any tactical
  /// advantages to performing work inside this stream transformation vs doing it
  /// in methods like [increment()] and [decrement()] we still get the same
  /// streaming properties of the bloc and we also have a much easier time
  /// catching errors and responding to specific results.
  Stream<CounterState> mapEventToState(CounterEvent event) async* {
    /// as per our discussion, events should not be commands, I 100% agree. they just just notify the bloc that something happened, work is done elsewhere
    /// so in this case what happened was that the count changed and so the state updates
    if (event is CounterStateTransitionEvent) {
      yield event.nextState;
    }
  }

  /// Events should not be commands, but there still needs to be commands in the app such as reacting to specific user input.
  /// this code could just as well be in the widget but this is business logic that
  /// is more profitably kept here so that the widget can stay dumb. we just wire up
  /// a button push or something else to this method. this is equivalent to `bloc.add(CounterEvent.increment)`, except
  /// now we have some more clarity and control over how we react to this signal
  Future<void> increment() async {
    var currentCount = state.count;
    // so if we want to keep the loading state in the state model, we could do that here
    add(CounterStateTransitionEvent(CounterState(currentCount, true)));
    // pretend this takes a longtime and might fail
    await Future.delayed(Duration(seconds: 1));
    if(currentCount == 3) {
      // but if we add the loading state to the state model, we need to clean it up here, this ends up being easier to do in the widget in my experience actually
      add(CounterStateTransitionEvent(CounterState(currentCount, false)));
      throw 'not today!';
    }
    add(CounterStateTransitionEvent(CounterState(currentCount + 1)));
    /// The event here ends up being just a dumb container for the state I want to emit.
    /// So the only fundamental improvement I want to think about here is a 1st class
    /// way to cause a transition that doesn't require me to send a shuttle event
  }

  Future<void> decrement() async {
    var currentCount = state.count;
    add(CounterStateTransitionEvent(CounterState(currentCount, true)));
    // pretend this takes a longtime and might fail
    await Future.delayed(Duration(seconds: 1));
    add(CounterStateTransitionEvent(CounterState(currentCount - 1)));
  }
}
