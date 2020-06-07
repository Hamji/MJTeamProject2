import 'package:bitsync/pages/authbasedpage.dart';
import 'package:bitsync/pages/pages.dart';
import 'package:bitsync/widgets/myblocprovider.dart';
import 'package:flutter/material.dart';
import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';

class UserRoomsPage extends AuthBasedPage {
  final String uid;

  UserRoomsPage({Key key, @required this.uid}) : super(key: key);

  @override
  Widget onAuthenticated(BuildContext context, User user) {
    return MyBlocProvider<UserRoomsBloc, UserRoomsState>.withBuilder(
      create: (context) => UserRoomsBloc(),
      builder: (context, state) {
        if (state is UserRoomsStateResponse) {
          final rooms = state.rooms;
          return Scaffold(
              appBar: AppBar(),
              body: ListView.builder(
                itemBuilder: (context, index) =>
                    _buildItem(context, rooms[index]),
                itemCount: rooms.length,
              ));
        } else if (state is UserRoomsStateInitial)
          context.userRoomsBloc.add(UserRoomsEventInit(uid));
        return LoadingPage();
      },
    );
  }

  static Widget _buildItem(BuildContext context, RoomData room) {
    // room.name || room.roomId
  }
}
