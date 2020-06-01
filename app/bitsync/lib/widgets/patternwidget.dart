import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:flutter/material.dart';

import './patternwidgets.dart';

class PatternWidget extends StatelessWidget {
  final Pattern pattern;
  final SequenceDesignerStateLoaded state;

  PatternWidget(this.pattern, this.state)
      : assert(null != pattern),
        assert(null != state);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[]; // <Widget>[const Text("Sub-patterns")];
    for (int i = 0; i < pattern.size; i++)
      children.add(PatternElementWidget(pattern[i], state));
    bool isRoot = state.sequence == pattern;

    var widget = Container(
      padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
      child: Column(children: children),
      decoration: isRoot
          ? BoxDecoration(
              border: Border.all(
                color: state.selectedElement == null
                    ? PATTERN_SELECTED_COLOR
                    : Colors.grey,
                width: 1,
                style: BorderStyle.solid,
              ),
              // borderRadius: BorderRadius.circular(3),
            )
          : null,
    );

    return isRoot
        ? GestureDetector(
            child: widget,
            onTap: () => context.sequenceDesignerBloc.add(
              SequenceDesignerEventSelect(
                sequence: state.sequence,
                selectedElement: null,
              ),
            ),
          )
        : widget;
  }
}
