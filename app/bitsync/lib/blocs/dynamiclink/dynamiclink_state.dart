import 'package:equatable/equatable.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DynamicLinkState extends Equatable {
  const DynamicLinkState();
  @override
  List<Object> get props => const [];
}

class DynamicLinkStateInitial extends DynamicLinkState {
  const DynamicLinkStateInitial();
}

class DynamicLinkStateLoading extends DynamicLinkState {
  const DynamicLinkStateLoading();
}

class DynamicLinkStateNone extends DynamicLinkState {
  const DynamicLinkStateNone();
}

class DynamicLinkStateUpdated extends DynamicLinkState {
  final PendingDynamicLinkData data;
  DynamicLinkStateUpdated(this.data);
  @override
  List<Object> get props => [data];
}
