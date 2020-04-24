import 'package:bitsync/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirebaseTestApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BitSync",
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatelessWidget {
  final FSTestBloc _testBloc = FSTestBloc();

  _MyHomePage({Key key}) : super(key: key);

  void _setCounter(final int value) =>
      _testBloc.add(FSTestEventUpload(value: value));

  @override
  Widget build(BuildContext context) => BlocBuilder(
        bloc: _testBloc,
        builder: (final context, final state) {
          if (state is FSTestStateUpdated)
            return Scaffold(
              appBar: AppBar(
                title: const Text("BitSync"),
              ),
              body: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      'You have pushed the button this many times:',
                    ),
                    Text(
                      '${state.value}',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => _setCounter(state.value + 1),
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ),
            );
          else if (state is FSTestStateInitial)
            _testBloc.add(const FSTestEventInitialize());
          return Scaffold(
            appBar: AppBar(
              title: const Text("BitSync"),
            ),
            body: Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          );
        },
      );
}
