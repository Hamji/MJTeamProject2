import 'dart:async';

import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:bitsync/errors/errors.dart';
import 'package:bitsync/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export './user_event.dart';
export './user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  DocumentReference _documentReference;
  StreamSubscription _streamSubscription;

  @override
  get initialState => const UserStateInitial();

  @override
  Stream<UserState> mapEventToState(event) async* {
    if (event is UserEventError)
      yield UserStateError(uid: event.uid, error: event.error);
    else if (event is UserEventRequestData) {
      yield UserStateLoading();
      _startListening(event.uid);
    } else if (event is UserEventReceivedData)
      yield UserStateLoaded(user: event.user);
  }

  void _stopListening() {
    if (null != _streamSubscription) {
      _streamSubscription.cancel();
      _streamSubscription = null;
    }
  }

  void _startListening(final String uid) {
    _stopListening();
    _documentReference = FirestoreRefs.user(uid);
    _documentReference.snapshots().listen(_onData);
  }

  void _onData(final DocumentSnapshot snapshot) {
    if (snapshot.exists)
      this.add(UserEventReceivedData(
        user: User.fromMap(
          uid: snapshot.documentID,
          map: snapshot.data,
        ),
      ));
    else
      this.add(UserEventError(
        uid: snapshot.documentID,
        error: const NotFoundException(),
      ));
  }

  @override
  Future<void> close() {
    _stopListening();
    return super.close();
  }
}
