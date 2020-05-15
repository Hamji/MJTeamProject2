import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class BeatDesignerState extends Equatable {
  const BeatDesignerState();
}

class BeatDesignerStateInitial extends BeatDesignerState {
  const BeatDesignerStateInitial();
  @override
  List<Object> get props => const [];
}
