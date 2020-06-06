import 'package:bitsync/data/data.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class UserRoomsState {
  const UserRoomsState();
}

class UserRoomsStateInitial extends UserRoomsState {
  const UserRoomsStateInitial();
}

class UserRoomsStateLoading extends UserRoomsState implements EquatableMixin {
  final String uid;
  UserRoomsStateLoading(this.uid);
  @override
  List<Object> get props => [uid];
  @override
  bool get stringify => false;
}

class UserRoomsStateResponse extends UserRoomsState implements EquatableMixin {
  final String uid;
  final List<RoomData> rooms;

  UserRoomsStateResponse({
    @required this.uid,
    @required this.rooms,
  });

  @override
  List<Object> get props => [uid, rooms];

  @override
  bool get stringify => false;
}
