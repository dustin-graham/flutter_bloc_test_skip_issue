import 'package:equatable/equatable.dart';

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
