import 'package:bitsync/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class RoomPage extends StatelessWidget {
  final String roomId;

  RoomPage({@required this.roomId});

  @override
  Widget build(final BuildContext context) => BlocProvider(
        create: (final context) => RoomBloc(),
        child: _RoomPageNested(roomId: roomId),
      );
}

class _RoomPageNested extends StatelessWidget {
  final String roomId;

  _RoomPageNested({@required this.roomId});

  @override
  Widget build(final BuildContext context) {}
}
