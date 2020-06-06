import 'dart:async';
import 'dart:io';

import 'package:bitsync/services/dynamiclinkservice.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './dynamiclink_event.dart';
import './dynamiclink_state.dart';

class DynamicLinkBloc extends Bloc<DynamicLinkEvent, DynamicLinkState> {
  String _oldLink = "";
  StreamSubscription _subscription;

  @override
  DynamicLinkState get initialState => const DynamicLinkStateInitial();

  @override
  Stream<DynamicLinkState> mapEventToState(
      final DynamicLinkEvent event) async* {
    if (event is DynamicLinkEventUpdated) {
      if (_oldLink != event.data?.link?.path ?? null) {
        _oldLink = event.data?.link?.path ?? null;
        yield event.data == null
            ? DynamicLinkStateNone()
            : DynamicLinkStateUpdated(event.data);
      }
    } else if (event is DynamicLinkEventRequestUpdate) {
      yield const DynamicLinkStateLoading();
      _init();
    }
  }

  void _init() async {
    print("================ REQUEST UPDATE");
    if (null == _subscription) {
      _subscription = DynamicLinkService.stream.listen(_onSuccess);
      DynamicLinkService.initialize();
    }
    if (Platform.isIOS) await Future.delayed(const Duration(seconds: 3));
    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    add(DynamicLinkEventUpdated(data));
  }

  @override
  Future<void> close() {
    print("=============== CLOSE");
    _subscription.cancel();
    return super.close();
  }

  void _onSuccess(PendingDynamicLinkData data) {
    print("============ LINK UPDATED: ${data.link}");
    add(DynamicLinkEventUpdated(data));
  }

  void refresh() => add(DynamicLinkEventRequestUpdate());
}
