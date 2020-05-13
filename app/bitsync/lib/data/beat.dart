import 'package:cloud_firestore/cloud_firestore.dart';

enum PatternType { mute, small, medium, large, subPattern }

class PatternElement {
  PatternType type;
  Pattern subPattern;

  PatternElement({this.type, this.subPattern});

  PatternElement.fromMap(final Map<dynamic, dynamic> map) {
    type = PatternType.values[(map["type"] as int)];
    this.subPattern = type == PatternType.subPattern
        ? Pattern.fromMap(map["subPattern"])
        : null;
  }

  Map<dynamic, dynamic> toMap() => {
        "type": type.index,
        "subPattern": subPattern == null ? null : subPattern.toMap()
      };
}

class Pattern {
  int size;
  List<PatternElement> elements;

  Pattern({this.size, this.elements});

  Pattern.fromMap(final Map<dynamic, dynamic> map) {
    size = map["size"];
    elements = (map["elements"] as List<Map<dynamic, dynamic>>)
        .map((e) => PatternElement.fromMap(e))
        .toList();
  }

  Map<dynamic, dynamic> toMap() => {
        "size": size,
        "elements": elements.map((e) => e.toMap()).toList(),
      };
}

class Sequence extends Pattern {
  Pattern pattern;
  double duration;
  int repeatCount;

  Sequence({
    this.pattern,
    this.duration,
    this.repeatCount = -1,
  });

  Sequence.fromMap(final Map<dynamic, dynamic> map) {
    repeatCount = map["repeatCount"];
    duration = map["duration"];
    pattern = Pattern.fromMap(map["pattern"]);
  }

  Map<dynamic, dynamic> toMap() => {
        "pattern": pattern.toMap(),
        "duration": duration,
        "repeatCount": repeatCount
      };
}

class Beat {
  int size;
  List<Sequence> sequence;

  Beat({this.size = 0, this.sequence = const []});

  Beat.fromMap(final Map<String, dynamic> map) {
    size = map["size"];
    sequence = (map["sequence"] as List<Map<dynamic, dynamic>>)
        .map((e) => Sequence.fromMap(e))
        .toList();
  }

  Map<String, dynamic> toMap() => {
        "size": size,
        "sequence": sequence.map((s) => s.toMap()).toList(),
      };
}
