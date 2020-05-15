import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class RoomPage extends StatelessWidget {
  final String roomId;

  RoomPage({@required this.roomId});

  @override
  Widget build(final BuildContext context) => BlocBuilder(
        bloc: context.bloc<RoomBloc>(),
        builder: (context, state) {
          return MyScaffold(
            appBar: AppBar(
              title: Text(roomId),
            ),
            body: Center(
              child: Text(roomId),
            ),
          );
        },
      );
}
