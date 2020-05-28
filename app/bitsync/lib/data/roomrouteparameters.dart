import 'package:flutter/material.dart';

@immutable
class RoomRouteParameters {
  final String roomId;
  final BuildContext parentContext;
  final bool createIfNotExist;

  RoomRouteParameters({
    @required this.roomId,
    @required this.parentContext,
    this.createIfNotExist = false,
  });
}
