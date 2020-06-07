import 'dart:async';

import 'package:bitsync/data/data.dart';
import 'package:bitsync/pages/loadingpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class BeepPlayerProvider extends StatefulWidget {
  final Widget Function(BuildContext context, BeepPlayer beepPlayer) builder;

  BeepPlayerProvider({Key key, this.builder}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BeepPlayerPrividerState();

  Widget build(BuildContext context, BeepPlayer beepPlayer) =>
      builder(context, beepPlayer);
}

class _BeepPlayerPrividerState extends State<BeepPlayerProvider> {
  int delay;
  Soundpool pool;
  BeepPlayer player;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    delay = (await LocalPreferences.getInstance()).beepSoundDelay;

    pool = Soundpool(streamType: StreamType.music);

    int low = await rootBundle
        .load("assets/sounds/beep_low.wav")
        .then((data) => pool.load(data));
    int high = await rootBundle
        .load("assets/sounds/beep_high.wav")
        .then((data) => pool.load(data));

    setState(() => player = BeepPlayer(pool, low, high, delay));
  }

  @override
  Widget build(BuildContext context) {
    if (null == player)
      return LoadingPage();
    else
      return widget.build(context, player);
  }

  @override
  void dispose() async {
    super.dispose();
    if (null != pool) {
      await pool.release();
      player?.invalidate();
      player = null;
    }
  }
}

const _DELAY_BASE = 0;
const _DELAY_HIGH = _DELAY_BASE + 5000;
const _DELAY_LOW = _DELAY_BASE + 10000;

class BeepPlayer {
  final int _delay;
  final Soundpool _pool;
  final int _low;
  final int _high;

  int _streamLow;
  int _streamHigh;

  BeepPlayer(Soundpool pool, int low, int high, int delay)
      : this._pool = pool,
        this._low = low,
        this._high = high,
        this._delay = -delay;

  void playLow() async {
    if (null != _streamLow) await _pool.stop(_streamLow);
    _streamLow = await _pool.play(_low);
  }

  void playHigh() async {
    if (null != _streamHigh) await _pool.stop(_streamHigh);
    _streamHigh = await _pool.play(_high);
  }

  PatternType _queuedType;
  int _queuedTimestamp;
  Timer _task;

  void queue(final int timestamp, final PatternType type) async {
    if ((type == PatternType.large || type == PatternType.medium) &&
        (_queuedTimestamp != timestamp || _queuedType != type)) {
      _task?.cancel();
      _queuedType = type;
      _queuedTimestamp = timestamp;
      int wait = timestamp - getTimestamp() + _delay;
      Function play;
      if (type == PatternType.large) {
        wait -= _DELAY_HIGH;
        play = playHigh;
      } else {
        wait -= _DELAY_LOW;
        play = playLow;
      }
      if (wait > 0)
        _task = Timer(Duration(microseconds: wait), () async {
          await play.call();
        });
    }
  }

  void invalidate() {
    _task.cancel();
  }
}
