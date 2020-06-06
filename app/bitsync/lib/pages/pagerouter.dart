import 'dart:async';

import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:bitsync/pages/loadingpage.dart';
import 'package:bitsync/pages/pages.dart';
import 'package:bitsync/routes/routes.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PageRouter extends StatelessWidget with WidgetsBindingObserver {
  @override
  Widget build(final BuildContext context) {
    return MyBlocProvider<DynamicLinkBloc, DynamicLinkState>.withBuilder(
      create: (_) => DynamicLinkBloc(),
      builder: (context, state) {
        if (state is DynamicLinkStateNone)
          return _build(context);
        else if (state is DynamicLinkStateUpdated) {
          print("============= ROOMID ${state.data.link.pathSegments[1]}");
          Navigator.pushNamed(
            context,
            state.data.link.pathSegments[0],
            arguments: RoomRouteParameters(
              parentContext: context,
              roomId: state.data.link.pathSegments[1],
            ),
          );
          return _build(context);
        } else if (state is DynamicLinkStateInitial)
          context.dynamicLinkBloc.refresh();
        return LoadingPage();
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Timer(const Duration(milliseconds: 850), () {});
    }
  }

  Widget _build(BuildContext context) => MaterialApp(
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
        initialRoute: "/",
        onGenerateRoute: Routing.onGenerateRoute,
      );
}
