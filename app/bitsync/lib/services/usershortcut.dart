import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserReference {
  static DocumentReference of(final String uid) =>
      Firestore.instance.collection("users").document(uid);
}
