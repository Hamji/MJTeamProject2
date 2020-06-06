import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
class User extends Equatable {
  final String uid;
  final String nickname;
  final String photoUrl;

  User({
    @required this.uid,
    @required this.nickname,
    @required this.photoUrl,
  });

  User.fromFirebaseUser({@required FirebaseUser firebaseUser})
      : this.uid = firebaseUser.uid,
        this.nickname = firebaseUser.displayName,
        this.photoUrl = firebaseUser.photoUrl;

  User.fromMap({@required final String uid, @required Map<String, dynamic> map})
      : this.uid = uid,
        this.nickname = map["nickname"],
        this.photoUrl = map["photoUrl"];

  Map<String, dynamic> toMap() => <String, dynamic>{
        "nickname": nickname,
        "photoUrl": photoUrl,
      };

  @override
  List<Object> get props => [uid, nickname, photoUrl];

  String get myRoomID =>
      (uid.hashCode % 1000000000).toString().padLeft(9, "0");
}
