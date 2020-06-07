import 'package:bitsync/data/data.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class RoomListState {
  const RoomListState();
}

class RoomListStateInitial extends RoomListState {
  const RoomListStateInitial();
}

class RoomListStateLoading extends RoomListState implements EquatableMixin {
  final String uid;
  RoomListStateLoading(this.uid);
  @override
  List<Object> get props => [uid];
  @override
  bool get stringify => false;
}

class RoomListStateResponse extends RoomListState implements EquatableMixin {
  final String uid;
  final List<RoomData> rooms;

  RoomListStateResponse({
    @required this.uid,
    @required this.rooms,
  });

  @override
  List<Object> get props => [uid, rooms];

  @override
  bool get stringify => false;
}
