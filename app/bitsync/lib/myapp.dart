import 'package:bitsync/routes/routes.dart';
import 'package:flutter/material.dart';

final _routes = {
  "/my-profile": (settings) => MyProfileRoute(settings),
  "/preference": (settings) => PreferenceRoute(settings),
  "/rooms": (settings) => RoomRoute(settings),
  "/": (_) => RootRoute(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
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
        // home: RootPage(),
        initialRoute: "/",
        // routes: {
        //   "/": (context) => RootPage(),
        //   "/my-profile": (context) => MyProfilePage(),
        // },
        onGenerateRoute: (settings) =>
            (_routes[settings.name] ?? _routes["/"])(settings),
      );
}