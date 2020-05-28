import 'package:bitsync/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kOffsetOfTouchTimestamp = "offsetOfTouchTimestamp";

class LocalPreferences {
  /// microseconds
  static Future<int> offsetOfTouchTimestamp() =>
      SharedPreferences.getInstance().then((prefs) =>
          prefs.getInt(_kOffsetOfTouchTimestamp) ??
          INITIAL_OFFSET_OF_TOUCH_TIMESTAMP);

  /// microseconds
  static Future<bool> setOffsetOfTouchTimestamp(int value) =>
      SharedPreferences.getInstance()
          .then((prefs) => prefs.setInt(_kOffsetOfTouchTimestamp, value));
}
