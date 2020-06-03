import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_test_skip_issue/main.dart';
import 'package:flutter_bloc_test_skip_issue/my_bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  group('MyHomePage', () {
    final myBloc = MockMyBlocBloc();

    Future<void> _pumpWidget(WidgetTester tester) async {
      await tester.pumpWidget(BlocProvider<MyBlocBloc>(
        create: (context) => myBloc,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('should load with a basic pre-configured state',
        (tester) async {
      mockBlocState(
        myBloc,
        Stream<MyBlocState>.fromIterable([
          LoadedMyBlocState(0),
        ]),
        currentState: LoadedMyBlocState(0),
      );

      await _pumpWidget(tester);

      expect(find.text('loaded'), findsOneWidget);
    });

    testWidgets('should be able to control the stream through a subject',
        (tester) async {
      final stateSubject =
          BehaviorSubject<MyBlocState>.seeded(LoadedMyBlocState(0));
      when(myBloc.increment()).thenAnswer((realInvocation) {
        stateSubject.add(LoadedMyBlocState(1));
      });
      mockBlocState(
        myBloc,
        stateSubject,
        currentState: LoadedMyBlocState(0),
      );

      await _pumpWidget(tester);
      expect(find.text('loaded'), findsOneWidget);
      expect(find.text('count: 0'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('count: 1'), findsOneWidget);
    });
  });
}

class MockMyBlocBloc extends MockBloc<MyBlocEvent, MyBlocState>
    implements MyBlocBloc {}

void mockBlocState<Event, State>(
  Bloc<Event, State> bloc,
  Stream<State> stream, {
  State currentState,
}) {
  whenListen(bloc, stream);
  if (currentState != null) {
    when(bloc.state).thenReturn(currentState);
  }
}
