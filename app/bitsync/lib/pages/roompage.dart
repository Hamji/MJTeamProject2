import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:bitsync/pages/loadingpage.dart';
import 'package:bitsync/views/views.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class RoomPage extends StatelessWidget {
  final String roomId;
  final bool createIfNotExit;

  RoomPage({@required this.roomId, this.createIfNotExit = false});

  @override
  Widget build(final BuildContext context) => BlocBuilder<RoomBloc, RoomState>(
        bloc: context.bloc<RoomBloc>(),
        builder: (context, state) {
          if (state is RoomStateInitial)
            context.bloc<RoomBloc>().add(RoomEventInit(roomId: roomId));
          else if (state is RoomStateNotFound) {
            if (createIfNotExit) {
              var data = RoomData(roomId: roomId);
              data.startAt = DateTime.now().microsecondsSinceEpoch;
              data.currentIndex = 0;
              data.duration = 2.0;
              data.sequence = [
                Sequence(
                  size: 4,
                  elements: [
                    PatternElement(type: PatternType.large),
                    PatternElement(type: PatternType.small),
                    PatternElement(type: PatternType.small),
                    PatternElement(type: PatternType.small),
                  ],
                ),
              ];
              context.bloc<RoomBloc>().add(RoomEventCreate(data: data));
            } else
              return MyScaffold(
                appBar: AppBar(
                  title: Text(_makeRoomId(roomId)),
                ),
                body: Center(
                  child: Column(
                    children: [
                      Text(
                        _makeRoomId(state.roomId),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Text("Not Found"),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              );
          } else if (state is RoomStateUpdate)
            return MyScaffold(
              appBar: AppBar(
                title: Text(roomId),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    tooltip: "Invite",
                    onPressed: () => state.data.invite(context),
                  ),
                ],
              ),
              body: RoomView(roomData: state.data),
              backgroundColor: Colors.black,
            );
          return LoadingPage();
        },
      );

  String _makeRoomId(String roomId) =>
      "${roomId.substring(0, 3)} ${roomId.substring(3, 6)} ${roomId.substring(6)}";
}
