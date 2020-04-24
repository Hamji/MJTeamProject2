import 'dart:async';

import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:bitsync/errors/errors.dart';
import 'package:bitsync/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import './auth_event.dart';
import './auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'profile',
    // 'https://www.googleapis.com/auth/contacts.readonly'
  ]);

  final UserBloc _userBloc = UserBloc();
  StreamSubscription _profileSubscription;

  @override
  AuthState get initialState => AuthStateInitial();

  @override
  Stream<AuthState> mapEventToState(final AuthEvent event) async* {
    if (event is AuthEventInitialize) {
      yield const AuthStateLoading();
      final user = await _firebaseAuth.currentUser();
      if (null == user)
        yield const AuthStateSignedOut();
      else
        _onSignIn(user);
    } else if (event is AuthEventRequestSignOut) {
      yield const AuthStateLoading();
      _profileSubscription?.cancel();
      _profileSubscription = null;
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      yield AuthStateSignedOut();
    } else if (event is AuthEventRequestSignInWithGoogle) {
      yield const AuthStateLoading();
      _authWithGoogle();
    } else if (event is AuthEventError)
      yield AuthStateError(error: event.error, authType: event.authType);
    else if (event is AuthEventSignedIn)
      yield AuthStateSignedIn(user: event.user);
    else if (event is AuthEventRequestUpdateProfile) {
      yield* _updateUserProfile(event);
    }
  }

  Stream<AuthState> _updateUserProfile(
      final AuthEventRequestUpdateProfile event) async* {
    bool needUpdate = false;

    yield AuthStateUpdating(previousEvent: event);
    final user = await _firebaseAuth.currentUser();
    final info = UserUpdateInfo();
    var data = Map<String, dynamic>();
    if (null != event.nickname) {
      needUpdate = true;
      data["nickname"] = event.nickname;
      info.displayName = event.nickname;
    }
    needUpdate |= null != event.photo;
    if (needUpdate) {
      yield AuthStateUpdating(previousEvent: event);

      if (null != event.photo) {
        needUpdate = true;
        final storage =
            FirebaseStorage.instance.ref().child("users/${user.uid}/avata");
        final uploadTask = storage.putFile(event.photo);
        await uploadTask.onComplete;
        final photoUrl = await storage.getDownloadURL();
        data["photoUrl"] = photoUrl;
        info.photoUrl = photoUrl;
      }

      await Future.wait([
        user.updateProfile(info),
        UserReference.of(user.uid).updateData(data)
      ]);
      yield AuthStateSignedIn(user: User.fromFirebaseUser(firebaseUser: user));
    }
  }

  void _authWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      final authentication = await account.authentication;
      final credential = GoogleAuthProvider.getCredential(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken);
      final result = await _firebaseAuth.signInWithCredential(credential);

      if (null == result.user)
        this.add(AuthEventError(
          error: new Exception("No Account"),
          authType: "Google",
        ));
      else
        _onSignIn(result.user);
    } on Exception catch (error) {
      this.add(AuthEventError(error: error, authType: "Google"));
    }
  }

  void _onSignIn(final FirebaseUser user) async {
    final reference = UserReference.of(user.uid);

    _profileSubscription = _userBloc.listen((state) async {
      if (state is UserStateError && state.error is NotFoundException) {
        final userData = User.fromFirebaseUser(firebaseUser: user);
        await reference.setData(userData.toMap());
      } else if (state is UserStateLoaded)
        this.add(AuthEventSignedIn(user: state.user));
    });
    _userBloc.add(UserEventRequestData(uid: user.uid));
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    _profileSubscription = null;
    return super.close();
  }
}
