import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:bitsync/pages/loadingpage.dart';
import 'package:bitsync/settings.dart';
import 'package:bitsync/widgets/myblocprovider.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

const _selectedColor = Colors.lightBlue;

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
                    const SizedBox(width: 8),
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
    var children = <Widget>[const Text("Sub-patterns")];
    for (int i = 0; i < pattern.size; i++)
      children.add(_ElementWidget(pattern[i], state));
    bool isRoot = state.sequence == pattern;

    var widget = Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
      child: Column(children: children),
      decoration: isRoot
          ? BoxDecoration(
              border: Border.all(
                color: state.selectedElement == null
                    ? _selectedColor
                    : Colors.grey,
                width: 1,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(3),
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
                  ? _selectedColor
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

class _PatternEditor extends StatelessWidget {
  final SequenceDesignerStateLoaded state;

  _PatternEditor(this.state);

  Widget _buildTypeSelectTile(final BuildContext context,
      final PatternElement element, final PatternType type,
      {Function action}) {
    bool selected = type == element.type;
    return ListTile(
      leading: selected
          ? const Icon(Icons.radio_button_checked, color: _selectedColor)
          : const Icon(Icons.radio_button_unchecked),
      title: Text(
        type.name,
        style: selected ? const TextStyle(color: _selectedColor) : null,
      ),
      onTap: selected
          ? null
          : action ??
              () {
                element.type = type;
                context.sequenceDesignerBloc
                    .add(SequenceDesignerEventUpdate(state));
              },
    );
  }

  @override
  Widget build(final BuildContext context) {
    var element = state.selectedElement;
    List<Widget> children = [];
    if (null != element) {
      children.addAll([
        Text("Beat Type: ${element.type.name}"),
        _buildTypeSelectTile(context, element, PatternType.large),
        _buildTypeSelectTile(context, element, PatternType.medium),
        _buildTypeSelectTile(context, element, PatternType.small),
        _buildTypeSelectTile(context, element, PatternType.mute),
      ]);
      if (state.sequence.getDepth(state.selectedElement) <
          SUB_PATTERN_MAX_DEPTH)
        children.add(_buildTypeSelectTile(
          context,
          element,
          PatternType.subPattern,
          action: () {
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
        ));
      children.add(const Divider());
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
                minValue: PATTERN_DIVIDE_MIN,
                maxValue: PATTERN_DIVIDE_MAX,
                initialIntegerValue: pattern.size,
                title: const Text("Select Sub-beat size"),
              ),
            );
            context.sequenceDesignerBloc
                .add(SequenceDesignerEventUpdate(state));
          },
        )
      ]);
    }

    return ListView(children: children);
  }
}

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
