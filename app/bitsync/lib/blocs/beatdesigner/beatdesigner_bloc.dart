import 'package:flutter_bloc/flutter_bloc.dart';

import './beatdesigner_event.dart';
import './beatdesigner_state.dart';

class BeatDesignerBloc extends Bloc<BeatDesignerEvent, BeatDesignerState> {
  @override
  BeatDesignerState get initialState => const BeatDesignerStateInitial();

  @override
  Stream<BeatDesignerState> mapEventToState(
    final BeatDesignerEvent event,
  ) async* {

    
  }
}
