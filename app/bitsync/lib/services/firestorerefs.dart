import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRefs {
  static DocumentReference room(final String id) =>
      Firestore.instance.collection("rooms").document(id);

  static DocumentReference user(final String id) =>
      Firestore.instance.collection("users").document(id);
}
