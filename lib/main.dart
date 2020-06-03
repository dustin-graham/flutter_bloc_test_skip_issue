import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_test_skip_issue/counter/bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
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
    final counterBloc = BlocProvider.of<CounterBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: BlocBuilder<CounterBloc, CounterState>(
          bloc: counterBloc,
          builder: (context, state) {
            return Center(
              child: Text('count: ${state.count}, loading: ${state.isLoading}'),
            );
          },
        ),
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
                  await counterBloc.increment();
                  /// easy to respond to the user
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('did the thing')));
                } catch (e) {
                  /// easy to get a handle on problems in the right context
                  print(e);
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text(e)));
                }
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
              counterBloc.decrement();
            },
            label: Text('Send Event'),
            icon: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
