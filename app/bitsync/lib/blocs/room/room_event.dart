import 'package:bitsync/data/roomdata.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RoomEvent extends Equatable {}

class RoomEventInit extends RoomEvent {
  final String roomId;

  RoomEventInit({@required this.roomId});

  @override
  List<Object> get props => [roomId];
}

class RoomEventReceived extends RoomEvent {
  final RoomData data;

  RoomEventReceived({@required this.data});

  @override
  List<Object> get props => [data];
}

class RoomEventNotFound extends RoomEvent {
  final String roomId;

  RoomEventNotFound({@required this.roomId});

  @override
  List<Object> get props => [roomId];
}
