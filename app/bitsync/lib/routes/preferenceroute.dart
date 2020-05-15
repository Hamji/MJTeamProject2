import 'package:bitsync/blocs/auth/auth.dart';
import 'package:bitsync/pages/pages.dart';
import 'package:bitsync/routes/authbaseroute.dart';
import 'package:flutter/material.dart';

class PreferenceRoute extends AuthBaseRoute {
  PreferenceRoute({
    @required final AuthBloc authBloc,
    final RouteSettings settings,
  }) : super(
          authBloc: authBloc,
          settings: settings,
          builder: (context) => PreferencePage(),
        );
}
