import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_test_skip_issue/my_bloc/my_bloc_state.dart';

abstract class MyBlocEvent extends Equatable {
  const MyBlocEvent();

  @override
  List<Object> get props => [];
}

class LoadMyBlocEvent extends MyBlocEvent {
  final int count;

  LoadMyBlocEvent(this.count);

  @override
  List<Object> get props => super.props..add(count);
}

class PerformAProcessEvent extends MyBlocEvent {
  final int importantArg;

  PerformAProcessEvent(this.importantArg);

  @override
  List<Object> get props => super.props..add(importantArg);
}

class LoadedStateUpdated extends MyBlocEvent {
  // I realize this is gross, i'm not actually advocating this pattern, but it does illustrate my point which is
  // that often we find these event classes less useful. they are just shuttling information that
  // could be done in a simpler way
  final LoadedMyBlocState stateIWant;

  LoadedStateUpdated(this.stateIWant);

  @override
  List<Object> get props => super.props..add(stateIWant);
}