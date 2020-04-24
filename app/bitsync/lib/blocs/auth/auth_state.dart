import 'package:bitsync/blocs/auth/auth_event.dart';
import 'package:bitsync/data/data.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  bool isSameAuthState(final AuthState other) => this == other;
}

class AuthStateInitial extends AuthState {
  const AuthStateInitial();
  @override
  List<Object> get props => const [];
}

abstract class AuthStateUID extends AuthState {
  String get uid;

  @override
  bool isSameAuthState(final AuthState other) => other is AuthStateUID
      ? this.uid == other.uid
      : super.isSameAuthState(other);
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
  @override
  List<Object> get props => const [];
}

class AuthStateSignedOut extends AuthState {
  const AuthStateSignedOut();
  @override
  List<Object> get props => const [];
}

class AuthStateSignedIn extends AuthStateUID {
  final User user;
  AuthStateSignedIn({@required this.user});
  @override
  List<Object> get props => [user];
  @override
  String get uid => user.uid;
}

class AuthStateUpdating extends AuthStateUID {
  final AuthEventRequestUpdateProfile previousEvent;

  AuthStateUpdating({@required this.previousEvent});

  @override
  List<Object> get props => [previousEvent];

  @override
  String get uid => previousEvent.uid;
}

class AuthStateError extends AuthState {
  final Exception error;
  final String authType;
  AuthStateError({@required this.error, @required this.authType});
  @override
  List<Object> get props => [error];
}
