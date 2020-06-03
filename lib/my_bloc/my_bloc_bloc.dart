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
    if (event is LoadMyBlocEvent) {
      yield LoadedMyBlocState(event.count);
    }
  }

  void load() {
    add(LoadMyBlocEvent(0));
  }

  void increment() {
    final currentState = state;
    if (currentState is LoadedMyBlocState) {
      add(LoadMyBlocEvent(currentState.count+1));
    }
  }

  static MyBlocBloc get(BuildContext context) {
    return BlocProvider.of(context);
  }
}
