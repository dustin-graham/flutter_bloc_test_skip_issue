import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_test_skip_issue/my_bloc/bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyBlocBloc()..load(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final myBloc = MyBlocBloc.get(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: BlocBuilder<MyBlocBloc, MyBlocState>(
            bloc: myBloc,
            builder: (context, state) {
              if (state == null) {
                return Text('null');
              } else if (state is LoadedMyBlocState) {
                return Column(
                  children: <Widget>[
                    Text('loaded'),
                    Text('count: ${state.count}'),
                  ],
                );
              } else {
                return Text('not loaded');
              }
            }),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Builder(
            builder: (context) => FloatingActionButton.extended(
              onPressed: () async {
                try {
                  /// easy to await
                  /// easy to find the processing code, just command click with IDE
                  await myBloc.performAProcess(9);
                } catch (e) {
                  /// easy to get a handle on problems in the right context
                  print(e);
                }
                /// easy to respond to the user
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('did the thing')));
              },
              label: Text('Call a method'),
              icon: Icon(Icons.add),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              // problemA: it would be most convenient to get a Future that can be wrapped in a
              // try/catch, easier to throw snackbars up and makes the state model
              // easier to describe. A failure to do this one process shouldn't necessarily
              // change the state as it's something that happens in one instant rather than actually a "state" of the running program
              // it's awkward to put error messages in the state model especially when the errors need to be shown once they happen,
              // not persistently. When you send everything in an event to the bloc you lose the direct handle on the execution.
              // you can work around it by passing Completers around but this can become very hard to follow and debug
              // additionally you can't just command click into the function that
              // does this work, you've got to go find the Bloc class and search for the event in the mapping function then follow it through
              myBloc.add(PerformAProcessEvent(7));
            },
            label: Text('Send Event'),
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
