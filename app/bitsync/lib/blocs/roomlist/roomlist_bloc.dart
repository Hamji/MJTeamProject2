import 'dart:async';

import 'package:bitsync/data/data.dart';
import 'package:bitsync/services/firestorerefs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './roomlist_event.dart';
import './roomlist_state.dart';

class RoomListBloc extends Bloc<RoomListEvent, RoomListState> {
  StreamSubscription _subscription;

  @override
  RoomListState get initialState => const RoomListStateInitial();

  @override
  Stream<RoomListState> mapEventToState(RoomListEvent event) async* {
    if (event is RoomListEventInit) {
      yield RoomListStateLoading(event.uid);
      _startListening(event.uid);
    } else if (event is RoomListEventResponse) {
      yield RoomListStateResponse(uid: event.uid, rooms: event.rooms);
    }
  }

  void _startListening(final String uid) {
    _stopListening();
    _subscription = FirestoreRefs.roomsOwnedBy(uid).snapshots().listen((event) {
      add(RoomListEventResponse(
        uid: uid,
        rooms: event.documents
            .map((e) => RoomData.fromMap(
                  roomId: e.documentID,
                  map: e.data,
                ))
            .toList(),
      ));
    });
  }

  void _stopListening() {
    if (null != _subscription) {
      _subscription.cancel();
      _subscription = null;
    }
  }

  @override
  Future<void> close() {
    _stopListening();
    return super.close();
  }
}
