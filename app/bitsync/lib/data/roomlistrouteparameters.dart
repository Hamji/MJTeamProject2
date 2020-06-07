import 'package:bitsync/data/data.dart';
import 'package:flutter/material.dart';

@immutable
class RoomListRouteParameters {
  /// previous BuildContext
  final BuildContext parentContext;

  /// Room list owner
  final User listOwner;

  /// * **parentContext** is BuildContext of previous route.
  /// * **listOwner** is room list owner
  RoomListRouteParameters({
    @required this.parentContext,
    @required this.listOwner,
  });
}
