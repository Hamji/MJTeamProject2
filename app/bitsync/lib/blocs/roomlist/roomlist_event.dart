import 'package:bitsync/data/data.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class RoomListEvent extends Equatable {}

class RoomListEventInit extends RoomListEvent {
  final String uid;
  RoomListEventInit(this.uid);
  @override
  List<Object> get props => [uid];
}

class RoomListEventResponse extends RoomListEvent {
  final String uid;
  final List<RoomData> rooms;
  RoomListEventResponse({this.uid, this.rooms});
  List<Object> get props => [uid, rooms];
}
