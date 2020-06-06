import 'package:bitsync/pages/loadingpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

abstract class BeepPlayerProvider extends StatefulWidget {
  BeepPlayerProvider({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BeepPlayerPrividerState();

  Widget build(BuildContext context, BeepPlayer beepPlayer);
}

class _BeepPlayerPrividerState extends State<BeepPlayerProvider> {
  Soundpool pool;
  BeepPlayer player;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    pool = Soundpool(streamType: StreamType.music);

    int low = await rootBundle
        .load("assets/sounds/beep_low.wav")
        .then((data) => pool.load(data));
    int high = await rootBundle
        .load("assets/sounds/beep_high.wav")
        .then((data) => pool.load(data));

    setState(() => player = BeepPlayer(pool, low, high));
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
    if (null != pool) {
      await pool.release();
      player = null;
    }
    super.dispose();
  }
}

class BeepPlayer {
  final Soundpool _pool;
  final int _low;
  final int _high;

  int _streamLow;
  int _streamHigh;

  BeepPlayer(Soundpool pool, int low, int high)
      : this._pool = pool,
        this._low = low,
        this._high = high;

  playLow() async {
    if (null != _streamLow) await _pool.stop(_streamLow);
    _streamLow = await _pool.play(_low);
  }

  playHigh() async {
    if (null != _streamHigh) await _pool.stop(_streamHigh);
    _streamHigh = await _pool.play(_high);
  }
}
