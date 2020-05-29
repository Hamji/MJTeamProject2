import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:bitsync/pages/loadingpage.dart';
import 'package:bitsync/widgets/myblocprovider.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class SequenceDesignPage
    extends MyBlocProvider<SequenceDesignerBloc, SequenceDesignerState> {
  SequenceDesignPage({Key key, @required Sequence sequence})
      : super.withBuilder(
          key: key,
          create: (context) => SequenceDesignerBloc(),
          builder: (context, state) {
            if (state is SequenceDesignerStateInitial)
              context.sequenceDesignerBloc
                  .add(SequenceDesignerEventInitialize(sequence));
            else if (state is SequenceDesignerStateLoaded)
              return MyScaffold(
                appBar: AppBar(
                  title: const Text("Edit Sequence"),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () => Navigator.pop(context, state.sequence),
                      tooltip: "Save",
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => context.sequenceDesignerBloc
                          .add(SequenceDesignerEventInitialize(sequence)),
                      tooltip: "Discard",
                    ),
                  ],
                ),
                body: Row(
                  children: [
                    Flexible(
                      child: _PatternWidget(state.sequence, state),
                      flex: 1,
                    ),
                    Flexible(
                      child: _PatternEditor(state),
                      flex: 1,
                    ),
                  ],
                ),
              );
            return LoadingPage();
          },
        );
}

class _PatternWidget extends StatelessWidget {
  final Pattern pattern;
  final SequenceDesignerStateLoaded state;

  _PatternWidget(this.pattern, this.state)
      : assert(null != pattern),
        assert(null != state);

  @override
  Widget build(BuildContext context) {
    var children = List<Widget>();
    for (int i = 0; i < pattern.size; i++)
      children.add(_ElementWidget(pattern.elements[i], state));

    var widget = Container(
      padding: const EdgeInsets.fromLTRB(32, 5, 5, 5),
      child: Column(children: children),
      color: pattern == state.selectedPattern ? Colors.blueGrey : null,
    );

    return pattern == state.sequence
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

class _ElementWidget extends StatelessWidget {
  final PatternElement element;
  final SequenceDesignerStateLoaded state;

  _ElementWidget(this.element, this.state);

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (element.type) {
      case PatternType.large:
        child = Column(
          children: [
            Container(
              height: 9,
              color: Colors.black,
            ),
            Flexible(
              child: const Center(
                  child: const Text("Large", textAlign: TextAlign.center)),
              flex: 1,
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        );
        break;
      case PatternType.medium:
        child = Column(
          children: [
            Container(
              height: 6,
              color: Colors.black87,
            ),
            Flexible(
              child: const Center(
                  child: const Text("Medium", textAlign: TextAlign.center)),
              flex: 1,
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        );
        break;
      case PatternType.small:
        child = Column(
          children: [
            Container(
              height: 3,
              color: Colors.black54,
            ),
            Flexible(
              child: const Center(
                  child: const Text("Small", textAlign: TextAlign.center)),
              flex: 1,
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        );
        break;
      case PatternType.mute:
        child = const Center(child: const Text("Mute"));
        break;
      case PatternType.subPattern:
        child = _PatternWidget(element.subPattern, state);
    }

    return Flexible(
      child: GestureDetector(
        child: Container(
          child: child,
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            border: Border.all(
              color: state.selectedElement == element
                  ? Colors.lightBlue
                  : Colors.grey,
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        onTap: () => context.sequenceDesignerBloc.add(
          SequenceDesignerEventSelect(
            sequence: state.sequence,
            selectedElement: element,
          ),
        ),
      ),
      flex: 1,
    );
  }
}

Map<PatternType, String> _beatTypeName = {
  PatternType.large: "Large",
  PatternType.medium: "Medium",
  PatternType.small: "Small",
  PatternType.mute: "Mute",
  PatternType.subPattern: "Sub-beat",
};

class _PatternEditor extends StatelessWidget {
  final SequenceDesignerStateLoaded state;

  _PatternEditor(this.state);

  @override
  Widget build(BuildContext context) {
    var element = state.selectedElement;
    List<Widget> children = [];
    if (null != element) {
      children.addAll([
        Text("Beat Type: ${_beatTypeName[element.type]}"),
        ListTile(
          title: const Text("Large"),
          onTap: element.type == PatternType.large
              ? null
              : () {
                  element.type = PatternType.large;
                  context.sequenceDesignerBloc
                      .add(SequenceDesignerEventUpdate(state));
                },
        ),
        ListTile(
          title: const Text("Medium"),
          onTap: element.type == PatternType.medium
              ? null
              : () {
                  element.type = PatternType.medium;
                  context.sequenceDesignerBloc
                      .add(SequenceDesignerEventUpdate(state));
                },
        ),
        ListTile(
          title: const Text("Small"),
          onTap: element.type == PatternType.small
              ? null
              : () {
                  element.type = PatternType.small;
                  context.sequenceDesignerBloc
                      .add(SequenceDesignerEventUpdate(state));
                },
        ),
        ListTile(
          title: const Text("Mute"),
          onTap: element.type == PatternType.mute
              ? null
              : () {
                  element.type = PatternType.mute;
                  context.sequenceDesignerBloc
                      .add(SequenceDesignerEventUpdate(state));
                },
        ),
        ListTile(
          title: const Text("Sub-beat"),
          onTap: element.type == PatternType.subPattern
              ? null
              : () {
                  if (null == element.subPattern)
                    element.subPattern = Pattern(size: 4, elements: [
                      PatternElement(type: element.type),
                      PatternElement(type: PatternType.mute),
                      PatternElement(type: PatternType.mute),
                      PatternElement(type: PatternType.mute),
                    ]);
                  element.type = PatternType.subPattern;
                  context.sequenceDesignerBloc
                      .add(SequenceDesignerEventUpdate(state));
                },
        ),
        Divider(),
      ]);
    }
    var pattern = state.selectedPattern;
    if (null != pattern) {
      children.addAll([
        Text("Beat properties"),
        ListTile(
          title: Text("Sub-beat Count: ${pattern.size}"),
          onTap: () async {
            pattern.size = await showDialog<int>(
              context: context,
              builder: (context) => NumberPickerDialog.integer(
                minValue: 2,
                maxValue: 7,
                initialIntegerValue: pattern.size,
                title: const Text("Select Sub-beat size"),
              ),
            );
            while (pattern.elements.length < pattern.size)
              pattern.elements.add(PatternElement(type: PatternType.mute));
            context.sequenceDesignerBloc
                .add(SequenceDesignerEventUpdate(state));
          },
        )
      ]);
    }

    return ListView(children: children);
  }
}
