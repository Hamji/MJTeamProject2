import 'package:bitsync/data/roomdata.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RoomState extends Equatable {
  const RoomState();
}

class RoomStateInitial extends RoomState {
  const RoomStateInitial();
  @override
  List<Object> get props => const [];
}

class RoomStateUpdate extends RoomState {
  final RoomData data;
  RoomStateUpdate({@required this.data});

  @override
  List<Object> get props => [data];
}

class RoomStateNotFound extends RoomState {
  final String roomId;

  RoomStateNotFound({@required this.roomId});

  @override
  List<Object> get props => [roomId];
}

class RoomStateLoading extends RoomState {
  final String roomId;

  RoomStateLoading({@required this.roomId});

  @override
  List<Object> get props => [roomId];
}
