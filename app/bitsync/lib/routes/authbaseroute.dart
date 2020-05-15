import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/routes/blocbaseroute.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthBaseRoute extends BlocBaseRoute<AuthBloc, AuthState> {
  AuthBaseRoute({
    @required final RouteSettings settings,
    @required final WidgetBuilder builder,
  }) : super(
          bloc: (settings.arguments as BuildContext).bloc<AuthBloc>(),
          settings: settings,
          builder: builder,
        );
}
