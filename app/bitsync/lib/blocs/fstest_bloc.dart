import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FSTestEvent extends Equatable {
  const FSTestEvent();
}

class FSTestEventInitialize extends FSTestEvent {
  const FSTestEventInitialize();
  @override
  List<Object> get props => const [];
}

class FSTestEventUpdated extends FSTestEvent {
  final int value;

  FSTestEventUpdated({@required this.value});

  @override
  List<Object> get props => [value];
}

class FSTestEventUpload extends FSTestEvent {
  final int value;
  FSTestEventUpload({@required this.value});
  @override
  List<Object> get props => [value];
}

@immutable
abstract class FSTestState extends Equatable {
  const FSTestState();
}

class FSTestStateInitial extends FSTestState {
  const FSTestStateInitial();
  @override
  List<Object> get props => const [];
}

class FSTestStateLoading extends FSTestState {
  const FSTestStateLoading();
  @override
  List<Object> get props => const [];
}

class FSTestStateUpdated extends FSTestState {
  final int value;

  FSTestStateUpdated({@required this.value});

  @override
  List<Object> get props => [value];
}

class FSTestBloc extends Bloc<FSTestEvent, FSTestState> {
  DocumentReference _reference;

  StreamSubscription _subscription;

  FSTestBloc() {
    _reference = Firestore.instance.collection("test").document("test");
  }

  @override
  FSTestState get initialState => const FSTestStateInitial();

  @override
  Stream<FSTestState> mapEventToState(FSTestEvent event) async* {
    if (event is FSTestEventUpload)
      _reference.setData({"value": event.value});
    else if (event is FSTestEventUpdated)
      yield FSTestStateUpdated(value: event.value);
    else if (event is FSTestEventInitialize) {
      yield const FSTestStateLoading();
      _startListening();
    }
  }

  void _onData(final DocumentSnapshot snapshot) => add(
      FSTestEventUpdated(value: snapshot.exists ? snapshot.data["value"] : 0));

  void _onError(error, StackTrace stackTrace) {
    print(error);
  }

  void _startListening() {
    _stopListening();
    _subscription = _reference.snapshots().listen(_onData, onError: _onError);
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
