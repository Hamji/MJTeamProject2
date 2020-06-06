import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/routes/blocbaseroute.dart';
import 'package:flutter/material.dart';

abstract class AuthBaseRoute extends BlocBaseRoute<AuthBloc, AuthState> {
  AuthBaseRoute({
    @required final RouteSettings settings,
    @required final WidgetBuilder builder,
  }) : super(
          bloc: (settings.arguments as BuildContext).authBloc,
          settings: settings,
          builder: builder,
        );
}
