import 'dart:async';

import 'package:bitsync/data/beat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './beatlist_event.dart';
import './beatlist_state.dart';

class BeatListBloc extends Bloc<BeatListEvent, BeatListState> {
  StreamSubscription _subscription;

  @override
  BeatListState get initialState => const BeatListStateInitial();

  @override
  Stream<BeatListState> mapEventToState(final BeatListEvent event) async* {
    if (event is BeatListEventRequest) {
      yield BeatListStateLoading(uid: event.uid);
      _startListen(event.uid);
    } else if (event is BeatListEventReceived)
      yield BeatListStateReceived(uid: event.uid, list: event.list);
    else if (event is BeatListEventError)
      yield BeatListStateError(
        uid: event.uid,
        message: event.message,
        error: event.error,
      );
  }

  @override
  Future<void> close() {
    _stopListen();
    return super.close();
  }

  void _startListen(final String uid) {
    _stopListen();
    Firestore.instance
        .collection("users")
        .document(uid)
        .collection("beatList")
        .snapshots()
        .listen((snapshot) => _onData(uid, snapshot), onError: _onError);
  }

  void _stopListen() {
    if (null != _subscription) {
      _subscription.cancel();
      _subscription = null;
    }
  }

  void _onData(final String uid, final QuerySnapshot snapshot) =>
      add(snapshot.documents?.isEmpty ?? true
          ? BeatListEventReceived(uid: uid, list: const [])
          : BeatListEventReceived(
              uid: uid,
              list: snapshot.documents
                  .where((element) => element.exists)
                  .map((e) => e.data)
                  .map((e) => Sequence.fromMap(e))
                  .toList()));

  void _onError() {}
}
