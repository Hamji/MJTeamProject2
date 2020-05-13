import 'dart:io';

import 'package:bitsync/data/data.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => const [];
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventRequestSignOut extends AuthEvent {
  const AuthEventRequestSignOut();
}

class AuthEventRequestSignInWithGoogle extends AuthEvent {
  const AuthEventRequestSignInWithGoogle();
}

class AuthEventError extends AuthEvent {
  final Exception error;
  final String authType;
  AuthEventError({@required this.error, @required this.authType});
  @override
  List<Object> get props => [error, authType];
}

class AuthEventSignedIn extends AuthEvent {
  final User user;
  AuthEventSignedIn({@required this.user});
  @override
  List<Object> get props => [user];
}

class AuthEventRequestUpdateProfile extends AuthEvent {
  final String uid;
  final String nickname;
  final File photo;

  AuthEventRequestUpdateProfile({
    @required this.uid,
    this.nickname,
    this.photo,
  });

  @override
  List<Object> get props => [uid, nickname, photo];
}
