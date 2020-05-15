import 'package:bitsync/pages/pages.dart';
import 'package:bitsync/routes/authbaseroute.dart';
import 'package:flutter/material.dart';

class PreferenceRoute extends AuthBaseRoute {
  PreferenceRoute(final RouteSettings settings)
      : super(
          settings: settings,
          builder: (context) => PreferencePage(),
        );
}
