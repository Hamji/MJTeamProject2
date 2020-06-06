import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/pages/pages.dart';
import 'package:bitsync/routes/roomroute.dart';
import 'package:flutter/material.dart';

class MyRoomRoute extends RoomRoute {
  MyRoomRoute(final RouteSettings settings)
      : super(
          settings,
          customBuilder: Builder(
            builder: (context) => RoomPage(
              roomId: "My room",
              onInitialize: (context, user) => RoomEventEnterMyRoom(user: user),
            ),
          ),
        );
}
