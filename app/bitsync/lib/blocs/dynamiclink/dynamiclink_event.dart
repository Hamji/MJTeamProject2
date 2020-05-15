import 'package:equatable/equatable.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DynamicLinkEvent extends Equatable {
  const DynamicLinkEvent();
  @override
  List<Object> get props => const [];
}

class DynamicLinkEventRequestUpdate extends DynamicLinkEvent {
  const DynamicLinkEventRequestUpdate();
}

class DynamicLinkEventUpdated extends DynamicLinkEvent {
  final PendingDynamicLinkData data;
  DynamicLinkEventUpdated(this.data);
  @override
  List<Object> get props => [data];
}
