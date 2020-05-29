import 'package:bitsync/data/data.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import './sequencedeginer_state.dart';

@immutable
abstract class SequenceDesignerEvent {
  const SequenceDesignerEvent();
}

class SequenceDesignerEventInitialize extends SequenceDesignerEvent
    implements EquatableMixin {
  final Sequence sequence;

  SequenceDesignerEventInitialize(this.sequence);

  @override
  List<Object> get props => [sequence];

  @override
  bool get stringify => false;
}

class SequenceDesignerEventSelect extends SequenceDesignerEvent
    implements EquatableMixin {
  final Sequence sequence;
  final PatternElement selectedElement;

  SequenceDesignerEventSelect({
    @required this.sequence,
    @required this.selectedElement,
  });

  @override
  List<Object> get props => [sequence, selectedElement];

  @override
  bool get stringify => false;
}

class SequenceDesignerEventUpdate extends SequenceDesignerEvent
    implements EquatableMixin {
  final SequenceDesignerStateLoaded currentState;
  SequenceDesignerEventUpdate(this.currentState);

  @override
  List<Object> get props => [currentState];

  @override
  bool get stringify => false;
}
