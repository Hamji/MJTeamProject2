import 'package:bitsync/data/beat.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class BeatListEvent extends Equatable {
  const BeatListEvent();
}

class BeatListEventRequest extends BeatListEvent {
  final String uid;
  BeatListEventRequest({@required this.uid});
  @override
  List<Object> get props => [uid];
}

class BeatListEventReceived extends BeatListEvent {
  final String uid;
  final List<Sequence> list;

  BeatListEventReceived({@required this.uid, @required this.list});

  @override
  List<Object> get props => [uid, list];
}

class BeatListEventError extends BeatListEvent {
  final String uid;
  final String message;
  final Exception error;

  BeatListEventError({
    @required this.uid,
    @required this.message,
    @required this.error,
  });

  @override
  List<Object> get props => [uid, error, message];
}
