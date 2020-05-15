import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:bitsync/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomRoute extends MaterialPageRoute {
  RoomRoute(final RouteSettings settings)
      : super(
          builder: (context) {
            final parameter = settings.arguments as RoomRouteParameters;
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                    value: parameter.parentContext.bloc<AuthBloc>()),
                BlocProvider(create: (_) => RoomBloc()),
              ],
              child: Builder(
                builder: (context) => RoomPage(roomId: parameter.roomId),
              ),
            );
          },
          settings: settings,
        );
}
