import 'package:bitsync/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kOffsetOfTouchTimestamp = "offsetOfTouchTimestamp";

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

  /// microseconds
  int get offsetOfTouchTimestamp =>
      _prefs.getInt(_kOffsetOfTouchTimestamp) ??
      INITIAL_OFFSET_OF_TOUCH_TIMESTAMP;

  int get offsetOfTouchTimestampMilliseconds => offsetOfTouchTimestamp ~/ 1000;

  /// microseconds
  Future<bool> setOffsetOfTouchTimestamp(int value) =>
      _prefs.setInt(_kOffsetOfTouchTimestamp, value);
}
