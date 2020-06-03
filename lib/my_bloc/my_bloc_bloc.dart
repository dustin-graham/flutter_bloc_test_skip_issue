import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './bloc.dart';

class MyBlocBloc extends Bloc<MyBlocEvent, MyBlocState> {
  @override
  MyBlocState get initialState => InitialMyBlocState();

  @override
  Stream<MyBlocState> mapEventToState(
    MyBlocEvent event,
  ) async* {
    // problemB: Looking through this list of events can be hard, it is visually hard to follow
    if (event is LoadMyBlocEvent) {
      yield LoadedMyBlocState(event.count);
      return; // we actually do this and avoid "else if" statements so as to give us some visual space between cases
    }
    if (event is PerformAProcessEvent) {
      yield* _performAProcess(event);
    }
    // problemC: not a way to statically verify that you've covered all the events here.
    // problemD: easy to make a simple mistake and not return after handling an event and you end up doing more than you should
    // yield InitialMyBlocState()

    // again, not actually advocating this pattern exactly (see note in the event class), just illustrating that we often find these event classes to be unnecessary indirection
    if (event is LoadedStateUpdated) {
      yield event.stateIWant;
    }
  }

  // extension to problemA: this is really the function that does what we want when we push the button.
  // But to get here we had to create a new class, pass that class into a sink, add an if statement in the mapEventToState function, and then call this generator
  // because of the indirection we loose some control. See the alternate version for a demo of what this could look like instead
  Stream<MyBlocState> _performAProcess(PerformAProcessEvent event) async* {
    await Future.delayed(Duration(seconds: 1));
    // uncaught errors in a bloc are not friendly to debug. the bloc just swallows them and the best way I've found to learn about them is to
    // add a logging bloc delegate. this probably has more to do with how Dart does streams than anything else but it can be a challenge
    // throw 'some problem'
    yield LoadedMyBlocState(event.importantArg);
  }

  /// The nice thing about this is that the caller gets a Future which is really nice to work with when dealing with user interactions.
  /// It's much easier to communicate to the user what is happening like throwing up a snackbar
  Future<void> performAProcess(int importantArg) async {
    // TODO: produce transition
    await Future.delayed(Duration(seconds: 1));
    // TODO: produce transition
    add(LoadedStateUpdated(LoadedMyBlocState(importantArg)));
    /// again, I'd rather not have to use an event at all here. If I had a handle on the underlying BehaviorSubject I would be able to just add the new loaded state directly from here
  }

  void load() {
    add(LoadMyBlocEvent(0));
  }

  void increment() {
    final currentState = state;
    if (currentState is LoadedMyBlocState) {
      add(LoadMyBlocEvent(currentState.count + 1));
    }
  }

  static MyBlocBloc get(BuildContext context) {
    return BlocProvider.of(context);
  }
}
