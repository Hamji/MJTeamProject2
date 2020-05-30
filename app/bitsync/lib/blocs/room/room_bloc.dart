import 'dart:async';

import 'package:bitsync/data/data.dart';
import 'package:bitsync/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './room_event.dart';
import './room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  StreamSubscription _subscription;
  DocumentReference _reference;

  @override
  RoomState get initialState => const RoomStateInitial();

  @override
  Stream<RoomState> mapEventToState(final RoomEvent event) async* {
    if (event is RoomEventInit) {
      _stopListening();
      yield RoomStateLoading(roomId: event.roomId);
      _startListening(event.roomId);
    } else if (event is RoomEventNotFound)
      yield RoomStateNotFound(roomId: event.roomId);
    else if (event is RoomEventReceived)
      yield RoomStateUpdate(data: event.data);
    else if (event is RoomEventCreate) {
      _stopListening();
      yield RoomStateLoading(roomId: event.data.roomId);
      _createNewRoom(event.data);
    } else if (event is RoomEventRequestUpdate) _updateRoomData(event.data);
  }

  void _updateRoomData(final RoomData data) async =>
      await FirestoreRefs.room(data.roomId).setData(data.toMap());

  @override
  Future<void> close() {
    _stopListening();
    return super.close();
  }

  void _startListening(final String id) {
    _reference = FirestoreRefs.room(id);
    _subscription = _reference.snapshots().listen(
          (event) => add(
            event.exists
                ? RoomEventReceived(
                    data: RoomData.fromMap(
                      roomId: event.documentID,
                      map: event.data,
                    ),
                  )
                : RoomEventNotFound(
                    roomId: event.documentID,
                  ),
          ),
        );
  }

  void _stopListening() {
    if (null != _subscription) {
      _subscription.cancel();
      _subscription = null;
    }
  }

  void _createNewRoom(RoomData data) async {
    assert(data.roomId?.isNotEmpty ?? false);
    await FirestoreRefs.room(data.roomId).setData(data.toMap());
    _startListening(data.roomId);
  }

  /// duration mean current sequence duration
  void updateBpm(int timestamp, {double duration = 0.0}) async {
    assert(state is RoomStateUpdate);
    var room = (state as RoomStateUpdate).data;
    Map<String, dynamic> data = {"startAt": timestamp};
    if (duration > 0.0) data["duration"] = room.duration = duration;
    room.startAt = timestamp;

    await FirestoreRefs.room(room.roomId).updateData(data);
  }
}
