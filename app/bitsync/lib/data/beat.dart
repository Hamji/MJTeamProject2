import './utils.dart';

enum PatternType { mute, small, medium, large, subPattern }

class PatternElement {
  PatternType type;
  Pattern subPattern;

  PatternElement({this.type, this.subPattern});

  PatternElement.fromMap(final Map<dynamic, dynamic> map) {
    type = PatternType.values[map.getInt("type")];
    this.subPattern = type == PatternType.subPattern
        ? Pattern.fromMap(map["subPattern"])
        : null;
  }

  Map<dynamic, dynamic> toMap() => {
        "type": type.index,
        "subPattern": subPattern == null ? null : subPattern.toMap()
      };

  PatternElement clone() => PatternElement(
        type: this.type,
        subPattern: this.subPattern?.clone() ?? null,
      );
}

class Pattern {
  int size;
  List<PatternElement> elements;

  Pattern({this.size, this.elements});

  Pattern.fromMap(final Map<dynamic, dynamic> map) {
    loadFromMap(map);
  }

  Map<dynamic, dynamic> toMap() => {
        "size": size,
        "elements": elements.map((e) => e.toMap()).toList(),
      };

  void loadFromMap(final Map<dynamic, dynamic> map) {
    size = map.getInt("size");
    elements = (map["elements"] as List)
        .map((e) => e as Map<dynamic, dynamic>)
        .map((e) => PatternElement.fromMap(e))
        .toList();
  }

  Pattern clone() {
    var t = Pattern();
    copyTo(t);
    return t;
  }

  void copyTo<T extends Pattern>(T destination) {
    destination.size = this.size;
    destination.elements = this.elements.map((e) => e.clone()).toList();
  }
}

class Sequence extends Pattern {
  int repeatCount;

  Sequence({
    this.repeatCount = -1,
    int size,
    List<PatternElement> elements,
  }) : super(
          size: size,
          elements: elements,
        );

  Sequence.createDefault()
      : this(
          size: 4,
          elements: [
            PatternElement(type: PatternType.large),
            PatternElement(type: PatternType.small),
            PatternElement(type: PatternType.small),
            PatternElement(type: PatternType.small),
          ],
        );

  Sequence.fromMap(final Map<dynamic, dynamic> map) {
    loadFromMap(map);
  }

  Map<dynamic, dynamic> toMap() {
    var map = super.toMap();
    map["repeatCount"] = repeatCount;
    return map;
  }

  @override
  void loadFromMap(Map<dynamic, dynamic> map) {
    super.loadFromMap(map);
    repeatCount = map.getInt("repeatCount");
  }

  @override
  Sequence clone() {
    var obj = Sequence(repeatCount: repeatCount);
    super.copyTo(obj);
    return obj;
  }
}

class Beat {
  int size;
  List<Sequence> sequence;

  Beat({this.size = 0, this.sequence = const []});

  Beat.fromMap(final Map<String, dynamic> map) {
    size = map.getInt("size");
    sequence = (map["sequence"] as List<Map<dynamic, dynamic>>)
        .map((e) => Sequence.fromMap(e))
        .toList();
  }

  Map<String, dynamic> toMap() => {
        "size": size,
        "sequence": sequence.map((s) => s.toMap()).toList(),
      };
}
