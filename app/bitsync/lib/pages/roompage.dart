import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:bitsync/pages/pages.dart';
import 'package:bitsync/views/views.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class RoomPage extends AuthBasedPage {
  final String roomId;
  final bool createIfNotExit;
  final RoomEvent Function(BuildContext context, User user) onInitialize;

  RoomPage({
    Key key,
    @required this.roomId,
    this.onInitialize,
    this.createIfNotExit = false,
  }) : super(key: key);

  @override

  Widget build(final BuildContext context) => BlocBuilder<RoomBloc, RoomState>(
        bloc: context.roomBloc, 
  );
  Widget onAuthenticated(BuildContext context, User user) =>
      BlocBuilder<RoomBloc, RoomState>(
        bloc: context.roomBloc,

        builder: (context, state) {
          if (state is RoomStateInitial)
            context.roomBloc.add(null != onInitialize
                ? onInitialize(context, user)
                : RoomEventInit(roomId: roomId));
          else if (state is RoomStateNotFound) {
            if (createIfNotExit) {
              var data = RoomData(roomId: roomId, master: user.uid);
              data.startAt = DateTime.now().microsecondsSinceEpoch;
              data.currentIndex = 0;
              data.duration = 2.0;
              data.sequence = [Sequence.createDefault()];
              context.roomBloc.add(RoomEventCreate(data: data));
            } else
              return MyScaffold(
                appBar: AppBar(
                  title: Text(_makeRoomId(state.roomId)),
                ),
                body: Center(
                  child: Column(
                    children: [
                      Text(
                        _makeRoomId(state.roomId),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      const Text("Not Found"),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              );
          } else if (state is RoomStateUpdate)
            return MyScaffold(
              appBar: AppBar(
                title: Text(_makeRoomId(state.data.roomId)),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: "Edit Sequence",
                    onPressed: state.data.canEditBy(user.uid)
                        ? () async {
                            final Sequence sequence = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SequenceDesignPage(
                                    sequence: state.data.current),
                              ),
                            );
                            if (sequence != null) {
                              var data = state.data;
                              data.sequence[data.currentIndex] = sequence;
                              context.roomBloc
                                  .add(RoomEventRequestUpdate(data: data));
                            }
                          }
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    tooltip: "Invite",
                    onPressed: () => state.data.invite(context),
                  ),
                ],
              ),
              body: RoomView(
                roomData: state.data,
                canEdit: state.data.canEditBy(user.uid),
              ),
              backgroundColor: Colors.black,
              setDefaultPadding: false,
            );
          return LoadingPage();
        },
      );

  static String _makeRoomId(String roomId) =>
      "${roomId.substring(0, 3)} ${roomId.substring(3, 6)} ${roomId.substring(6)}";
}
