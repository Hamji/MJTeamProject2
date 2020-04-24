import 'package:bitsync/data/data.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserEvent extends Equatable {}

class UserEventRequestData extends UserEvent {
  final String uid;
  UserEventRequestData({@required this.uid});
  @override
  List<Object> get props => [uid];
}

class UserEventReceivedData extends UserEvent {
  final User user;
  UserEventReceivedData({@required this.user});
  @override
  List<Object> get props => [user];
}

class UserEventError extends UserEvent {
  final String uid;
  final Exception error;
  UserEventError({@required this.uid, @required this.error});
  @override
  List<Object> get props => [uid, error];
}
