import 'dart:async';

import 'package:bitsync/services/dynamiclinkservice.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './dynamiclink_event.dart';
import './dynamiclink_state.dart';

class DynamicLinkBloc extends Bloc<DynamicLinkEvent, DynamicLinkState> {
  StreamSubscription _subscription;

  @override
  DynamicLinkState get initialState => const DynamicLinkStateInitial();

  @override
  Stream<DynamicLinkState> mapEventToState(
      final DynamicLinkEvent event) async* {
    if (event is DynamicLinkEventUpdated) {
      yield event.data == null
          ? DynamicLinkStateNone()
          : DynamicLinkStateUpdated(event.data);
    } else if (event is DynamicLinkEventRequestUpdate) {
      yield const DynamicLinkStateLoading();
      _init();
    }
  }

  void _init() async {
    if (null == _subscription) {
      _subscription = DynamicLinkService.stream.listen(_onSuccess);
    }
    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    add(DynamicLinkEventUpdated(data));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  void _onSuccess(PendingDynamicLinkData data) async =>
      add(DynamicLinkEventUpdated(data));

  void refresh() => add(DynamicLinkEventRequestUpdate());
}
