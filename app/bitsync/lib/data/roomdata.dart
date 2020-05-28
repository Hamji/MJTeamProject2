import 'package:meta/meta.dart';
import 'package:bitsync/data/beat.dart';

class RoomData {
  final String roomId;

  /// name of room
  String name;

  /// Microseconds since epoch
  int startAt;

  /// List of sequence
  List<Sequence> sequence;

  /// Index of current sequence
  int currentIndex;

  /// Invite url for reuse
  Uri inviteUrl;

  RoomData({@required this.roomId});

  /// Get current sequence
  Sequence get current => sequence[currentIndex];

  /// Convert to Map<String, dynamic>, use for firestore
  Map<String, dynamic> toMap() => {
        "name": name,
        "startAt": startAt,
        "sequence": sequence.map((e) => e.toMap()).toList(),
        "current": currentIndex,
      };

  /// Parse RoomData from Map<String, dynamic>, use for firestore
  RoomData.fromMap({
    @required this.roomId,
    @required Map<String, dynamic> map,
  }) {
    startAt = map["startAt"];
    sequence = (map["sequence"] as List)
        .map((e) => e as Map<dynamic, dynamic>)
        .map((e) => Sequence.fromMap(e))
        .toList();
    currentIndex = map["current"];
    name = map["name"];
  }
}
