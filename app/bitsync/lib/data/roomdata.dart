import 'package:meta/meta.dart';
import 'package:bitsync/data/beat.dart';

class RoomData {
  final String roomId;
  int startAt;
  List<Sequence> sequence;
  int currentIndex;

  RoomData({@required this.roomId});

  Sequence get current => sequence[currentIndex];

  Map<String, dynamic> toMap() => {
        "startAt": startAt,
        "sequence": sequence.map((e) => e.toMap()).toList(),
        "current": currentIndex,
      };

  RoomData.fromMap({
    @required this.roomId,
    @required Map<String, dynamic> map,
  }) {
    startAt = map["startAt"];
    sequence = (map["sequence"] as List<Map<dynamic, dynamic>>)
        .map((e) => Sequence.fromMap(e))
        .toList();
    currentIndex = map["current"];
  }
}
