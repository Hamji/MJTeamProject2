import 'package:flutter_bloc/flutter_bloc.dart';

import './sequencedeginer_state.dart';
import './sequencedesigner_event.dart';

class SequenceDesignerBloc
    extends Bloc<SequenceDesignerEvent, SequenceDesignerState> {
  int _update = 0;

  @override
  SequenceDesignerState get initialState =>
      const SequenceDesignerStateInitial();

  @override
  Stream<SequenceDesignerState> mapEventToState(
    final SequenceDesignerEvent event,
  ) async* {
    if (event is SequenceDesignerEventInitialize)
      yield SequenceDesignerStateLoaded(
        update: _update,
        sequence: event.sequence.clone(),
        selectedElement: null,
      );
    else if (event is SequenceDesignerEventSelect)
      yield SequenceDesignerStateLoaded(
        update: _update,
        sequence: event.sequence,
        selectedElement: event.selectedElement,
      );
    else if (event is SequenceDesignerEventUpdate)
      yield SequenceDesignerStateLoaded(
        update: ++_update,
        sequence: event.currentState.sequence,
        selectedElement: event.currentState.selectedElement,
      );
  }
}
