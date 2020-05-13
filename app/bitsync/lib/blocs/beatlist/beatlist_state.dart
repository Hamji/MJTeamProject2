import 'package:bitsync/data/beat.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class BeatListState extends Equatable {
  const BeatListState();

  @override
  List<Object> get props => const [];
}

class BeatListStateInitial extends BeatListState {
  const BeatListStateInitial();
}

class BeatListStateLoading extends BeatListState {
  final String uid;
  BeatListStateLoading({@required this.uid});
  @override
  List<Object> get props => [uid];
}

class BeatListStateReceived extends BeatListState {
  final String uid;
  final List<Beat> list;

  BeatListStateReceived({@required this.uid, @required this.list});

  @override
  List<Object> get props => [uid, list];
}

class BeatListStateError extends BeatListState {
  final String uid;
  final String message;
  final Exception error;

  BeatListStateError({
    @required this.uid,
    @required this.message,
    @required this.error,
  });

  @override
  List<Object> get props => [uid, error, message];
}
