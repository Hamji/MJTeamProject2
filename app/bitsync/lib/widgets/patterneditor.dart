import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:bitsync/settings.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import './patternwidgets.dart';

const _PROPERTY_TITLE_STYLE = const TextStyle(fontSize: 12);

class PatternEditor extends StatelessWidget {
  final SequenceDesignerStateLoaded state;

  PatternEditor(this.state);

  Widget _buildTypeSelectTile(final BuildContext context,
      final PatternElement element, final PatternType type,
      {Function action}) {
    bool selected = type == element.type;
    return ListTile(
      leading: selected
          ? const Icon(Icons.radio_button_checked,
              color: PATTERN_SELECTED_COLOR)
          : const Icon(Icons.radio_button_unchecked),
      title: Text(
        type.name,
        style: selected ? const TextStyle(color: PATTERN_SELECTED_COLOR) : null,
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
        Text("Beat Type: ${element.type.name}", style: _PROPERTY_TITLE_STYLE),
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
        const Text("Beat properties", style: _PROPERTY_TITLE_STYLE),
        ListTile(
          leading: const Icon(Icons.format_list_numbered_rtl),
          title: Text("Sub-beat Count: ${pattern.size}"),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            var size = await showDialog<int>(
              context: context,
              builder: (context) => NumberPickerDialog.integer(
                minValue: PATTERN_DIVIDE_MIN,
                maxValue: PATTERN_DIVIDE_MAX,
                initialIntegerValue: pattern.size,
                title: const Text("Select Sub-beat size"),
              ),
            );
            if (null != size) {
              pattern.size = size;
              context.sequenceDesignerBloc
                  .add(SequenceDesignerEventUpdate(state));
            }
          },
        )
      ]);
    }

    return ListView(children: children);
  }
}
