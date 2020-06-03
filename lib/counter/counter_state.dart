import 'package:meta/meta.dart';

@immutable
class CounterState {
  final int count;
  final bool isLoading;

  CounterState(this.count, [this.isLoading = false]);
}
