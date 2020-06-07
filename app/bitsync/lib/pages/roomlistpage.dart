import 'package:bitsync/pages/authbasedpage.dart';
import 'package:bitsync/pages/pages.dart';
import 'package:bitsync/routes/routes.dart';
import 'package:bitsync/widgets/myblocprovider.dart';
import 'package:flutter/material.dart';
import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';

class RoomListPage extends AuthBasedPage {
  final User owner;

  RoomListPage({Key key, @required this.owner}) : super(key: key);

  @override
  Widget onAuthenticated(BuildContext context, User user) {
    return MyBlocProvider<RoomListBloc, RoomListState>.withBuilder(
      create: (context) => RoomListBloc(),
      builder: (context, state) {
        if (state is RoomListStateResponse) {
          final rooms = state.rooms;
          return Scaffold(
              appBar: AppBar(
                title: Text("${user.nickname}'s list"),
              ),
              body: ListView.builder(
                itemBuilder: (context, index) =>
                    _buildItem(context, rooms[index]),
                itemCount: rooms.length,
              ));
        } else if (state is RoomListStateInitial)
          context.roomListBloc.add(RoomListEventInit(owner.uid));
        return LoadingPage();
      },
    );
  }

  static Widget _buildItem(BuildContext context, RoomData room) {
    String id = room.beautifyID;
    return ListTile(
      title: Text(room.name?.isNotEmpty ?? false ? room.name : id),
      subtitle: Text(id),
      trailing: const Icon(Icons.navigate_next),
      onTap: () => Routing.toRoom(context, roomId: room.roomId),
    );
  }
}
