import './utils.dart';

enum PatternType { mute, small, medium, large, subPattern }

const Map<PatternType, String> _patternTypeName = {
  PatternType.large: "Large",
  PatternType.medium: "Medium",
  PatternType.small: "Small",
  PatternType.mute: "Mute",
  PatternType.subPattern: "Sub-beat",
};

extension PatternTypeExtension on PatternType {
  String get name => _patternTypeName[this];
}

class Beat {
  final PatternType type;
  final int length;

  Beat(this.type, this.length);
}

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
  int _size;
  List<PatternElement> _elements;

  Pattern({int size, List<PatternElement> elements}) {
    _elements = elements;
    if (null != size || null != elements) this.size = size ?? elements.length;
  }

  Pattern.fromMap(final Map<dynamic, dynamic> map) {
    loadFromMap(map);
  }

  Map<dynamic, dynamic> toMap() => {
        "size": _size,
        "elements": _elements.map((e) => e.toMap()).toList(),
      };

  void loadFromMap(final Map<dynamic, dynamic> map) {
    _elements = (map["elements"] as List)
        .map((e) => e as Map<dynamic, dynamic>)
        .map((e) => PatternElement.fromMap(e))
        .toList();
    _size = map.getInt("size");
  }

  Pattern clone() {
    var t = Pattern();
    copyTo(t);
    return t;
  }

  void copyTo<T extends Pattern>(T destination) {
    destination._elements = this._elements.map((e) => e.clone()).toList();
    destination._size = this._size;
  }

  int get size => _size;
  set size(int value) {
    assert(0 <= value);
    _size = value;
    if (null == _elements) _elements = [];
    while (_elements.length < _size)
      _elements.add(PatternElement(type: PatternType.mute));
  }

  PatternElement operator [](int i) {
    assert(0 <= i && i < size);
    return _elements[i];
  }

  operator []=(int i, PatternElement value) {
    assert(0 <= i && i < size);
    _elements[i] = value;
  }

  void _getBeats(int length, List<Beat> result) {
    int subLength = length ~/ _size;
    PatternElement element = _elements[0];

    if (element.type == PatternType.subPattern)
      element.subPattern._getBeats(length - subLength * (_size - 1), result);
    else
      result.add(Beat(element.type, length - subLength * (_size - 1)));

    for (int i = 1; i < _size; i++) {
      element = _elements[i];
      if (element.type == PatternType.subPattern)
        element.subPattern._getBeats(subLength, result);
      else
        result.add(Beat(element.type, subLength));
    }
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

  List<Beat> _beats;

  /// length is microseconds
  List<Beat> getBeats(int length) {
    if (null == _beats) {
      _beats = List<Beat>();
      _getBeats(length, _beats);
    }
    return _beats;
  }
}
