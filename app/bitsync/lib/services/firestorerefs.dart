import 'dart:async';
import 'dart:math';

import 'package:bitsync/data/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRefs {
  static DocumentReference room(final String id) =>
      Firestore.instance.collection("rooms").document(id);

  static DocumentReference user(final String id) =>
      Firestore.instance.collection("users").document(id);

  static CollectionReference favoritBeats(final String uid) =>
      user(uid).collection("favoritBeats");

  static DocumentReference favoritBeat(final String uid, final String beatId) =>
      favoritBeats(uid).document(beatId);

  static Query roomsOwnedBy(final String uid) =>
      Firestore.instance.collection("rooms").where("master", isEqualTo: uid);

  static Future<DocumentReference> retrivMyRoom(final User user) async {
    var room = RoomData(
      roomId: null,
      master: user.uid,
      name: "${user.nickname}'s Room",
      sequence: [Sequence.createDefault()],
    );

    final Random rand = Random.secure();
    CollectionReference collection = Firestore.instance.collection("rooms");

    int mValue = 1000000000;
    int nCount = 9;
    int tryCount = 0;
    final data = room.toMap();

    final subRoutine = () async {
      if (tryCount > 10) {
        tryCount = 0;
        mValue *= 10;
        nCount += 1;
      }

      final completer = Completer<DocumentReference>();

      String id = rand.nextInt(mValue).toString().padLeft(nCount, "0");
      final ref = collection.document(id);
      Firestore.instance
          .runTransaction((transaction) => transaction.get(ref).then((value) {
                if (value.exists)
                  throw "Already Exists";
                else
                  return transaction.set(ref, data);
              }).then((value) => completer.complete(ref)))
          .catchError((e) => completer.complete(null));
      return completer.future;
    };

    for (;;) {
      var result = await subRoutine();
      if (null != result) {
        await FirestoreRefs.user(user.uid).updateData({
          "myRoom": result.documentID,
        });
        return result;
      }

      tryCount++;
    }
  }
}
