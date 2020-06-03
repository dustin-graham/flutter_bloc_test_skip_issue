import 'package:flutter_bloc/flutter_bloc.dart';

enum CounterEvent { increment, decrement }

class CounterBloc extends Bloc<CounterEvent, int> {
  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    switch (event) {
      case CounterEvent.decrement:
        /// same logic as in [counter_bloc.dart] decrement method
      /// but in this pattern all of our interactions with the bloc have to go
      /// through this switch statement which is an unnecessary lookup and gets
      /// complicated once the app gets interesting
      ///
      /// The main difference is where this code happens. This is happening
      /// essentially in the middle of our stream which is a bit more tricky
      /// to handle vs doing this work before we emit new state
        yield state - 1;
        break;
      case CounterEvent.increment:
        yield state + 1;
        break;
    }
  }
}
