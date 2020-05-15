import 'package:bitsync/pages/pages.dart';
import 'package:bitsync/routes/authbaseroute.dart';
import 'package:flutter/material.dart';

class MyProfileRoute extends AuthBaseRoute {
  MyProfileRoute(final RouteSettings settings)
      : super(
          settings: settings,
          builder: (context) => MyProfilePage(),
        );
}
