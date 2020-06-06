import 'package:bitsync/data/data.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class UserRoomsEvent extends Equatable {}

class UserRoomsEventInit extends UserRoomsEvent {
  final String uid;
  UserRoomsEventInit(this.uid);
  @override
  List<Object> get props => [uid];
}

class UserRoomsEventResponse extends UserRoomsEvent {
  final String uid;
  final List<RoomData> rooms;
  UserRoomsEventResponse({this.uid, this.rooms});
  List<Object> get props => [uid, rooms];
}
