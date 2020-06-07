import 'dart:math';

import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:bitsync/settings.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

int _touchTimeOffset = INITIAL_OFFSET_OF_TOUCH_TIMESTAMP;
double _dragScale = 1.0;
bool _enableDrag = false;

void _loadPreferences({Function callback}) async {
  var pref = await LocalPreferences.getInstance();
  _touchTimeOffset = pref.offsetOfTouchTimestamp;
  _enableDrag = pref.useBPMdrag;
  _dragScale = pref.dragBPMscale;
  callback?.call();
}

class BpmTapper extends StatefulWidget {
  final bool enabled;
  final TextStyle style;
  final RoomData roomData;

  BpmTapper({@required this.roomData, this.enabled = false, this.style});

  @override
  State<StatefulWidget> createState() => _BpmTapperState();
}

class _BpmTapperState extends State<BpmTapper> {
  static final _BpmRecorder _recorder = _BpmRecorder();

  bool preferenceLoaded;
  Offset dragStart;
  double currentBPM;
  double targetBpm;

  @override
  void initState() {
    preferenceLoaded = false;
    _loadPreferences(callback: () => setState(() => preferenceLoaded = true));
    super.initState();
  }

  Widget child(BuildContext context) => null == targetBpm
      ? Text(widget.roomData.bpm.toString(), style: widget.style)
      : Text(
          targetBpm.toStringAsFixed(0),
          style: widget.style?.apply(color: Colors.white60) ??
              const TextStyle(color: Colors.white60),
        );

  @override
  Widget build(final BuildContext context) {
    if (!widget.enabled) return child(context);

    return GestureDetector(
      onTap: () {
        final state = context.roomBloc.state;
        if (state is RoomStateUpdate) {
          _recorder.update(state.data);
          var timestamp = getTimestamp() - _touchTimeOffset;
          var sequenceDuration = _recorder.touch(state.data, timestamp);

          if (sequenceDuration > 0.0)
            context.roomBloc.updateTimeSync(
              _recorder.startAt,
              duration: sequenceDuration,
            );
          else
            context.roomBloc.updateTimeSync(_recorder.startAt);
        }
      },
      onLongPress: () async {
        if (null != dragStart) return;
        int newBPM = await showDialog<int>(
          context: context,
          builder: (context) => NumberPickerDialog.integer(
            initialIntegerValue: widget.roomData.bpm,
            minValue: 20,
            maxValue: 480,
            title: const Text("New BPM"),
          ),
        );
        if (null != newBPM) {
          _recorder.update(widget.roomData);
          _recorder.touch(widget.roomData, getTimestamp());
          context.roomBloc.updateTimeSync(_recorder.startAt, bpm: newBPM);
        }
      },
      onVerticalDragStart: _enableDrag
          ? (e) {
              dragStart = e.globalPosition;
              currentBPM = widget.roomData.bpm.toDouble();
            }
          : null,
      onVerticalDragUpdate: (e) {
        if (null != dragStart) {
          var delta = (e.globalPosition - dragStart);
          var vector = delta.dx + delta.dy * -0.1;
          vector *= _dragScale;
          double newTargetBpm = currentBPM + vector;
          setState(() => targetBpm = newTargetBpm);
        }
      },
      onVerticalDragCancel: () => setState(() {
        targetBpm = null;
        dragStart = null;
      }),
      onVerticalDragEnd: (e) {
        if (null != targetBpm) {
          _recorder.update(widget.roomData);
          _recorder.touch(widget.roomData, getTimestamp());
          context.roomBloc.updateTimeSync(
            _recorder.startAt,
            bpm: targetBpm.round(),
          );
        }
        targetBpm = null;
        dragStart = null;
      },
      child: child(context),
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
