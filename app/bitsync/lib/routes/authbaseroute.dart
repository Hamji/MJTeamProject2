import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/routes/blocbaseroute.dart';
import 'package:flutter/material.dart';

abstract class AuthBaseRoute extends BlocBaseRoute<AuthBloc, AuthState> {
  AuthBaseRoute({
    @required final AuthBloc authBloc,
    final RouteSettings settings,
    @required final WidgetBuilder builder,
  }) : super(
          bloc: authBloc,
          settings: settings,
          builder: builder,
        );
}
