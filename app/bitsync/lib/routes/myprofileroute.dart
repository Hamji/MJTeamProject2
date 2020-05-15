import 'package:bitsync/blocs/auth/auth.dart';
import 'package:bitsync/pages/pages.dart';
import 'package:bitsync/routes/authbaseroute.dart';
import 'package:flutter/material.dart';

class MyProfileRoute extends AuthBaseRoute {
  MyProfileRoute({
    @required final AuthBloc authBloc,
    final RouteSettings settings,
  }) : super(
          authBloc: authBloc,
          settings: settings,
          builder: (context) => MyProfilePage(),
        );
}
