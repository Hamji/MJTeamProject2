import 'dart:math';

import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:bitsync/settings.dart';
import 'package:flutter/material.dart';

int _touchTimeOffset = INITIAL_OFFSET_OF_TOUCH_TIMESTAMP;

void _loadPreferences() async =>
    _touchTimeOffset = await LocalPreferences.offsetOfTouchTimestamp();

class BpmTapper extends StatelessWidget {
  static final _BpmRecorder _recorder = _BpmRecorder();
  final Widget child;

  BpmTapper({@required this.child});

  @override
  Widget build(final BuildContext context) {
    _loadPreferences();
    return FlatButton(
      onPressed: () {
        final state = context.roomBloc.state;
        if (state is RoomStateUpdate) {
          _recorder.update(state.data);
          var timestamp = getTimestamp() - _touchTimeOffset;
          var sequenceDuration = _recorder.touch(state.data, timestamp);

          if (sequenceDuration > 0.0)
            context.roomBloc.updateBpm(
              _recorder.startAt,
              duration: sequenceDuration,
            );
          else
            context.roomBloc.updateBpm(_recorder.startAt);
        }
      },
      child: child,
    );
  }
}

/// a second
const MIN_TIMEOUT = 1000000;

class _BpmRecorder {
  int _size = -1;
  int _current = 0;
  int _maxSize = -1;
  int _startAt;
  int _timeout = 0;
  int _initDuration;

  final List<int> _saved = List<int>();

  void update(RoomData data) {
    if (_size != data.current.size) {
      _size = data.current.size;
      _maxSize = max(4, _size * 2);
      _initDuration = max(data.durationMicroseconds ~/ _size * 2, MIN_TIMEOUT);
      reset();
    }
  }

  /// return: Sequence Length if not recognized then return -1
  double touch(RoomData data, int timestamp) {
    if (_timeout > 0 && _timeout < timestamp) reset();
    if (_startAt == 0) _startAt = timestamp;

    _timeout = timestamp + _initDuration;

    if (_maxSize > _saved.length)
      _saved.add(timestamp);
    else {
      _saved[_current] = timestamp;
      _current = (_current + 1) % _saved.length;
    }

    if (_saved.length <= 1) return -1.0;

    int mux = 0;
    for (int i = 1; i < _saved.length; i++) {
      mux += _saved[(i + _current) % _saved.length] -
          _saved[(i - 1 + _current) % _saved.length];
    }
    int beatLength = mux ~/ (_saved.length - 1);

    _initDuration = max(beatLength * 2, MIN_TIMEOUT);

    _startAt = timestamp -
        data.getCurrentBeatIndex(timestamp, useRound: true) * beatLength;

    return (beatLength * _size).toDouble() * 1.0e-6;
  }

  void reset() {
    _saved.clear();
    _current = 0;
    _startAt = 0;
    _timeout = 0;
  }

  int get startAt => _startAt;
}
