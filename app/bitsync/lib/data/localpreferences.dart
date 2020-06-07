import 'package:bitsync/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kUseBeepSound = "useBeepSound";
const _kBeepSoundDelay = "beepSoundDelay";
const _kOffsetOfTouchTimestamp = "offsetOfTouchTimestamp";
const _kUseBPMdrag = "useBPMdrag";
const _kDragBPMscale = "dragBPMscale";

class LocalPreferences {
  static LocalPreferences _instance;

  SharedPreferences _prefs;

  static Future<LocalPreferences> getInstance() async {
    if (_instance == null) {
      _instance = LocalPreferences._();
      _instance._prefs = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  LocalPreferences._();

  bool get useBeepSound =>
      !_prefs.containsKey(_kUseBeepSound) || _prefs.getBool(_kUseBeepSound);

  Future<bool> setUseBeepSound(bool value) =>
      _prefs.setBool(_kUseBeepSound, value);

  int get beepSoundDelay => _prefs.containsKey(_kBeepSoundDelay)
      ? _prefs.getInt(_kBeepSoundDelay)
      : 0;

  Future<bool> setBeepSoundDelay(int value) =>
      _prefs.setInt(_kBeepSoundDelay, value);

  bool get useBPMdrag =>
      !_prefs.containsKey(_kUseBPMdrag) || _prefs.getBool(_kUseBPMdrag);

  Future<bool> setUseBPMdrag(bool value) => _prefs.setBool(_kUseBPMdrag, value);

  double get dragBPMscale => _prefs.containsKey(_kDragBPMscale)
      ? _prefs.getDouble(_kDragBPMscale)
      : 1.0;

  Future<bool> setDragBPMscale(double value) =>
      _prefs.setDouble(_kDragBPMscale, value);

  /// microseconds, when apply do subtract it to timestamp
  int get offsetOfTouchTimestamp =>
      _prefs.getInt(_kOffsetOfTouchTimestamp) ??
      INITIAL_OFFSET_OF_TOUCH_TIMESTAMP;

  int get offsetOfTouchTimestampMilliseconds => offsetOfTouchTimestamp ~/ 1000;

  /// microseconds
  Future<bool> setOffsetOfTouchTimestamp(int value) =>
      _prefs.setInt(_kOffsetOfTouchTimestamp, value);
}
