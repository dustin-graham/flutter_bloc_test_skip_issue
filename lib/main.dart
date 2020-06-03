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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          myBloc.increment();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
