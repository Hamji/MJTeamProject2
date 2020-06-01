import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TestEvent {
  const TestEvent();
}

class TestEventRequestUpdate extends TestEvent {
  final int value;
  TestEventRequestUpdate(this.value);
}

class TestEventValueChanged extends TestEvent {
  final int value;
  TestEventValueChanged(this.value);
}

class TestEventRequestInitialize extends TestEvent {
  const TestEventRequestInitialize();
}

@immutable
abstract class TestState {
  const TestState();
}

class TestStateLoading extends TestState {
  const TestStateLoading();
}

class TestStateInitial extends TestState {
  const TestStateInitial();
}

class TestStateReceive extends TestState {
  final int value;
  TestStateReceive(this.value);
}

class TestBloc extends Bloc<TestEvent, TestState> {
  DocumentReference _documentReference;
  StreamSubscription _streamSubscription;

  @override
  TestState get initialState => const TestStateInitial();

  @override
  Stream<TestState> mapEventToState(TestEvent event) async* {
    if (event is TestEventRequestInitialize) {
      yield const TestStateLoading();
      _startListening();
    }
    if (event is TestEventRequestUpdate) {
      yield const TestStateLoading();
      _updateValue(event.value);
    } else if (event is TestEventValueChanged) {
      yield TestStateReceive(event.value);
    }
  }

  void _updateValue(int value) async {
    // Map<String, dynamic>
    await _documentReference.setData(<String, dynamic>{
      "value": value,
    });

    print("update finished with $value");
  }

  void _startListening() {
    _stopListening();
    if (null == _documentReference) {
      _documentReference =
          Firestore.instance.collection("test").document("test");
    }

    _documentReference.snapshots().listen((event) {
      // value ?
      this.add(TestEventValueChanged(event.exists ? event.data["value"] : 0));

      // int value;
      // if (event.exists) {
      //   value = event.data["value"];
      // } else {
      //   value = 0;
      // }
      // this.add(TestEventValueChanged(value));
    });
  }

  void _stopListening() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  @override
  Future<void> close() {
    _stopListening();
    return super.close();
  }
}
