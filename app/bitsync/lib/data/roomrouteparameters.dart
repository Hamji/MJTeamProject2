import 'package:flutter/material.dart';

@immutable
class RoomRouteParameters {
  final String roomId;
  final BuildContext parentContext;

  RoomRouteParameters({@required this.roomId, @required this.parentContext});
}
