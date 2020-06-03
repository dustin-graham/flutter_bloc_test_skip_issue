import 'package:equatable/equatable.dart';

abstract class MyBlocState extends Equatable {
  const MyBlocState();

  @override
  List<Object> get props => [];
}

class InitialMyBlocState extends MyBlocState {}

class LoadedMyBlocState extends MyBlocState {
  final int count;

  LoadedMyBlocState(this.count);

  @override
  List<Object> get props => super.props..add(count);
}
