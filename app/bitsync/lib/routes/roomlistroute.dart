import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:bitsync/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomListRoute extends MaterialPageRoute {
  RoomListRoute(final RouteSettings settings)
      : super(
          builder: (context) {
            final parameter = settings.arguments as RoomListRouteParameters;
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(value: parameter.parentContext.authBloc),
                BlocProvider(create: (_) => RoomListBloc()),
              ],
              child: Builder(
                builder: (context) => RoomListPage(owner: parameter.listOwner),
              ),
            );
          },
          settings: settings,
        );
}
