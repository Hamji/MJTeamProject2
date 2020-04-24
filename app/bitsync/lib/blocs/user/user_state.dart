import 'package:bitsync/data/data.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserState extends Equatable {
  const UserState();
}

class UserStateInitial extends UserState {
  const UserStateInitial();
  @override
  List<Object> get props => const [];
}

class UserStateLoading extends UserState {
  const UserStateLoading();
  @override
  List<Object> get props => const [];
}

class UserStateLoaded extends UserState {
  final User user;
  UserStateLoaded({@required this.user});
  @override
  List<Object> get props => [user];
}

class UserStateError extends UserState {
  final String uid;
  final Exception error;
  UserStateError({@required this.uid, @required this.error});
  @override
  List<Object> get props => [uid, error];
}
