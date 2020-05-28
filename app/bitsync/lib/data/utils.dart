extension MapExtension on Map {
  int getInt(dynamic key, {int defaultValue = 0}) {
    if (this.containsKey(key)) {
      var value = this[key];
      if (value is int)
        return value;
      else if (value is double)
        return value.toInt();
      else
        return int.parse(value.toString());
    } else {
      return defaultValue;
    }
  }

  double getDouble(dynamic key, {double defaultValue = 0.0}) {
    if (this.containsKey(key)) {
      var value = this[key];
      if (value is double)
        return value;
      else if (value is int)
        return value.toDouble();
      else
        return double.parse(value.toString());
    } else {
      return defaultValue;
    }
  }
}

int getTimestamp() => DateTime.now().microsecondsSinceEpoch;

double microsecondToSecond(int microseconds) => microseconds * 1.0e-6;
