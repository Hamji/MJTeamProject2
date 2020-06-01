import 'package:bitsync/data/data.dart';
import 'package:flutter/material.dart';

export './patterneditor.dart';
export './patternelementwidget.dart';
export './patternwidget.dart';

const PATTERN_SELECTED_COLOR = Colors.lightBlue;

extension SequenceExtension on Pattern {
  /// not found return 0
  int getDepth(final PatternElement element) {
    if (element == null) return 0;
    for (int i = 0; i < this.size; i++) {
      var item = this[i];
      if (item == element)
        return 1;
      else if (PatternType.subPattern == item.type) {
        var value = item.subPattern.getDepth(element);
        if (value > 0) return value + 1;
      }
    }
    return 0;
  }
}
