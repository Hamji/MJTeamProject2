import 'package:bitsync/pages/pages.dart';
import 'package:flutter/material.dart';

class RootRoute extends MaterialPageRoute {
  RootRoute({final RouteSettings settings})
      : super(
          builder: (_) => MainPage(),
          settings:
              settings == null ? const RouteSettings(name: "/") : settings,
        );
}
