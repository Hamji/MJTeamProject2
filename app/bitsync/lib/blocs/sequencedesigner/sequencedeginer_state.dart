import 'package:bitsync/data/data.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SequenceDesignerState {
  const SequenceDesignerState();
}

class SequenceDesignerStateInitial extends SequenceDesignerState {
  const SequenceDesignerStateInitial();
}

class SequenceDesignerStateLoaded extends SequenceDesignerState
    implements EquatableMixin {
  final int update;
  final Sequence sequence;
  final PatternElement selectedElement;

  SequenceDesignerStateLoaded({
    @required this.update,
    @required this.sequence,
    @required this.selectedElement,
  });

  @override
  bool get stringify => false;

  @override
  List<Object> get props => [update, sequence, selectedElement];

  Pattern get selectedPattern => selectedElement == null
      ? sequence
      : selectedElement.type == PatternType.subPattern
          ? selectedElement.subPattern
          : null;
}
