import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:bitsync/pages/pages.dart';
import 'package:bitsync/services/services.dart';
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
                  title: Text(beautifyRoomID(state.roomId)),
                ),
                body: Center(
                  child: Column(
                    children: [
                      Text(
                        beautifyRoomID(state.roomId),
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
            return _RoomPageChild(user: user, room: state.data);
          return LoadingPage();
        },
      );
}

class _RoomPageChild extends StatefulWidget {
  final User user;
  final RoomData room;

  _RoomPageChild({@required this.user, @required this.room});

  @override
  State<StatefulWidget> createState() => _RoomPageChildState();
}

class _RoomPageChildState extends State<_RoomPageChild> {
  RoomData get room => widget.room;
  User get user => widget.user;

  int update;

  @override
  void initState() {
    update = 0;
    super.initState();
  }

  void refresh() => setState(() => ++update);

  @override
  Widget build(BuildContext context) => LocalPreferencesProvider(
        builder: (context, preference) => preference.useBeepSound
            ? BeepPlayerProvider(
                builder: (context, beepPlayer) =>
                    _buildWidget(context, preference, beepPlayer),
              )
            : _buildWidget(context, preference, null),
      );

  Widget _buildWidget(
    BuildContext context,
    LocalPreferences preference,
    BeepPlayer beepPlayer,
  ) {
    return MyScaffold(
      appBar: AppBar(
        title: Text(room.beautifyID),
        actions: [
          IconButton(
            icon: preference.useBeepSound
                ? const Icon(Icons.volume_up)
                : const Icon(Icons.volume_off),
            tooltip: "Toggle beep sound",
            onPressed: () async {
              if (await preference.setUseBeepSound(!preference.useBeepSound))
                refresh();
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "Edit Room",
            onPressed: room.canEditBy(user.uid)
                ? () async {
                    final Sequence sequence = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SequenceDesignPage(sequence: room.current),
                      ),
                    );
                    if (sequence != null) {
                      room.sequence[room.currentIndex] = sequence;
                      context.roomBloc.add(RoomEventRequestUpdate(data: room));
                    }
                  }
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: "Invite",
            onPressed: () => room.invite(context),
          ),
        ],
      ),
      body: RoomView(
        roomData: room,
        canEdit: room.canEditBy(user.uid),
        beepPlayer: beepPlayer,
      ),
      floatingActionButton: room.canEditBy(user.uid)
          ? FloatingActionButton(
              onPressed: () => context.roomBloc.updateTimeSync(
                  getTimestamp() - preference.offsetOfTouchTimestamp),
              child: const Icon(Icons.skip_next),
              tooltip: "Restart Now",
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      backgroundColor: Colors.black,
      setDefaultPadding: false,
    );
  }
}
