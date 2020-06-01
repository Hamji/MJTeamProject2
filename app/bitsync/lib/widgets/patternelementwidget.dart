import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:flutter/material.dart';

import './patternwidgets.dart';

const _patternSizes = <PatternType, double>{
  PatternType.large: 12,
  PatternType.medium: 9,
  PatternType.small: 6,
};

const _patternColors = <PatternType, Color>{
  PatternType.large: Colors.black,
  PatternType.medium: Colors.black87,
  PatternType.small: Colors.black54,
};

const _selectedBorderSide = const BorderSide(
  color: PATTERN_SELECTED_COLOR,
  width: 0.5,
  style: BorderStyle.solid,
);
const _unselectedBorderSide = const BorderSide(
  color: Colors.grey,
  width: 0.5,
  style: BorderStyle.solid,
);
const _selectedDecoration = const BoxDecoration(
  border: const Border.fromBorderSide(_selectedBorderSide),
);
const _unselectedDecoration = const BoxDecoration(
  border: const Border(
    top: _unselectedBorderSide,
    bottom: _unselectedBorderSide,
  ),
);

class PatternElementWidget extends StatelessWidget {
  final PatternElement element;
  final SequenceDesignerStateLoaded state;

  PatternElementWidget(this.element, this.state);

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (element.type) {
      case PatternType.large:
      case PatternType.medium:
      case PatternType.small:
        child = Column(
          children: [
            Container(
              height: _patternSizes[element.type],
              color: _patternColors[element.type],
            ),
            const Spacer(flex: 1),
          ],
        );
        break;
      case PatternType.mute:
        child = Container(); // const Center(child: const Text("Mute"));
        break;
      case PatternType.subPattern:
        child = PatternWidget(element.subPattern, state);
    }

    return Flexible(
      child: GestureDetector(
        child: Container(
          child: child,
          // margin: const EdgeInsets.all(3),
          // padding: const EdgeInsets.all(3),
          decoration: state.selectedElement == element
              ? _selectedDecoration
              : _unselectedDecoration,
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

// class PatternElementWidget extends StatelessWidget {
//   final PatternElement element;
//   final SequenceDesignerStateLoaded state;

//   PatternElementWidget(this.element, this.state);

//   @override
//   Widget build(BuildContext context) {
//     Widget child;
//     switch (element.type) {
//       case PatternType.large:
//         child = Column(
//           children: [
//             Container(
//               height: 9,
//               color: Colors.black,
//             ),
//             Flexible(
//               child: const Center(
//                   child: const Text("Large", textAlign: TextAlign.center)),
//               flex: 1,
//             )
//           ],
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//         );
//         break;
//       case PatternType.medium:
//         child = Column(
//           children: [
//             Container(
//               height: 6,
//               color: Colors.black87,
//             ),
//             Flexible(
//               child: const Center(
//                   child: const Text("Medium", textAlign: TextAlign.center)),
//               flex: 1,
//             )
//           ],
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//         );
//         break;
//       case PatternType.small:
//         child = Column(
//           children: [
//             Container(
//               height: 3,
//               color: Colors.black54,
//             ),
//             Flexible(
//               child: const Center(
//                   child: const Text("Small", textAlign: TextAlign.center)),
//               flex: 1,
//             )
//           ],
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//         );
//         break;
//       case PatternType.mute:
//         child = Container(); // const Center(child: const Text("Mute"));
//         break;
//       case PatternType.subPattern:
//         child = PatternWidget(element.subPattern, state);
//     }

//     return Flexible(
//       child: GestureDetector(
//         child: Container(
//           child: child,
//           margin: const EdgeInsets.all(3),
//           padding: const EdgeInsets.all(3),
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: state.selectedElement == element
//                   ? PATTERN_SELECTED_COLOR
//                   : Colors.grey,
//               width: 1,
//               style: BorderStyle.solid,
//             ),
//             borderRadius: BorderRadius.circular(3),
//           ),
//         ),
//         onTap: () => context.sequenceDesignerBloc.add(
//           SequenceDesignerEventSelect(
//             sequence: state.sequence,
//             selectedElement: element,
//           ),
//         ),
//       ),
//       flex: 1,
//     );
//   }
// }
