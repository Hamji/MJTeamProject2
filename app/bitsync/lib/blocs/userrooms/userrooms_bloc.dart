import 'dart:async';

import 'package:bitsync/data/data.dart';
import 'package:bitsync/services/firestorerefs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './userrooms_event.dart';
import './userrooms_state.dart';

class UserRoomsBloc extends Bloc<UserRoomsEvent, UserRoomsState> {
  StreamSubscription _subscription;

  @override
  UserRoomsState get initialState => const UserRoomsStateInitial();

  @override
  Stream<UserRoomsState> mapEventToState(UserRoomsEvent event) async* {
    if (event is UserRoomsEventInit) {
      yield UserRoomsStateLoading(event.uid);
      _startListening(event.uid);
    } else if (event is UserRoomsEventResponse) {
      yield UserRoomsStateResponse(uid: event.uid, rooms: event.rooms);
    }
  }

  void _startListening(final String uid) {
    _stopListening();
    _subscription = FirestoreRefs.roomsOwnedBy(uid).snapshots().listen((event) {
      add(UserRoomsEventResponse(
        uid: uid,
        rooms: event.documents
            .map((e) => RoomData.fromMap(roomId: e.documentID, map: e.data)),
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
