import 'package:meta/meta.dart';
import 'package:bitsync/data/beat.dart';
import './utils.dart';

class RoomData {
  final String roomId;

  /// name of room
  String name;

  /// master of room
  String master;

  /// password of room
  String password;

  /// Microseconds since epoch
  int startAt;

  /// List of sequence
  List<Sequence> sequence;

  /// Index of current sequence
  int currentIndex;

  /// Invite url for reuse
  Uri inviteUrl;

  /// Can write any person
  bool public;

  RoomData({
    @required this.roomId,
    @required this.master,
    this.name,
    this.password,
    this.startAt,
    this.sequence,
    this.currentIndex = 0,
    this.public = false,
  }) {
    if (null == this.startAt) this.startAt = getTimestamp();
  }

  /// Get current sequence
  Sequence get current => sequence[currentIndex];

  double duration;

  int get durationMicroseconds => (duration * 1e+6).toInt();

  int get bpm {
    var beatLength = duration / current.size;
    return (60.0 / beatLength).round();
  }

  /// Convert to Map<String, dynamic>, use for firestore
  Map<String, dynamic> toMap() => {
        "name": name,
        "startAt": startAt,
        "sequence": sequence.map((e) => e.toMap()).toList(),
        "current": currentIndex,
        "duration": duration,
        "master": master,
      };

  /// Parse RoomData from Map<String, dynamic>, use for firestore
  RoomData.fromMap({
    @required this.roomId,
    @required Map<String, dynamic> map,
  }) {
    print("=================== data from map ${this.roomId}, $map");
    startAt = map.getInt("startAt");
    sequence = (map["sequence"] as List)
        .map((e) => e as Map<dynamic, dynamic>)
        .map((e) => Sequence.fromMap(e))
        .toList();
    currentIndex = map.getInt("current");
    name = map["name"];
    duration = map.getDouble("duration", defaultValue: 2.0);
    master = map["master"];
  }
}

extension RoomDataExtension on RoomData {
  int getCurrentBeatIndex(int timestamp, {bool useRound = false}) {
    // find current beat
    var inseq = (timestamp - this.startAt) * 1.0e-6 / this.duration;
    inseq -= inseq.floorToDouble();
    inseq *= this.current.size;
    int currentBeat = useRound ? inseq.round() : inseq.floor();
    return currentBeat;
  }

  int get currentBeatIndex => this.getCurrentBeatIndex(getTimestamp());

  bool canEditBy(String uid) => this.public || this.master == uid;
}
