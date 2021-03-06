import 'dart:math' as math;

import 'package:fuzzylogic/models/dirt_level.dart';
import 'package:fuzzylogic/models/dirt_type.dart';
import 'package:fuzzylogic/utils/chart.dart';

///
class Washing {
  ///
  double time = 0;

  ///
  List<double> _washingY = List<double>.filled(61, 0);

  ///
  double _veryShort = 0, _short = 0, _medium = 0, _long = 0, _veryLong = 0;

  double computeTime(DirtLevel level, DirtType type) {
    _veryShort = math.min(level.getSmall, type.getNotGreasy);

    _short = math.min(level.getMedium, type.getNotGreasy);

    _medium = math.min(level.getLarge, type.getNotGreasy) +
        math.min(level.getSmall, type.getMedium) +
        math.min(level.getMedium, type.getMedium);

    _long = math.min(level.getLarge, type.getMedium) +
        math.min(level.getSmall, type.getGreasy) +
        math.min(level.getMedium, type.getGreasy);

    _veryLong = math.min(level.getLarge, type.getGreasy);

    buildChart();

    defuzzification();

    return time;
  }

  void buildChart() {
    for (int i = TIME_MIN; i <= WASHING_VERY_SHORT; i++) {
      _washingY[i] = _veryShort;
    }

    for (int i = WASHING_VERY_SHORT.toInt() + 1; i <= WASHING_SHORT; i++) {
      double y1 = math.min(_veryShort,
          (WASHING_SHORT - i) / (WASHING_SHORT - WASHING_VERY_SHORT));
      double y2 = math.min(_short,
          (i - WASHING_VERY_SHORT) / (WASHING_SHORT - WASHING_VERY_SHORT));
      _washingY[i] = math.max(y1, y2);
    }

    for (int i = WASHING_SHORT.toInt() + 1; i <= WASHING_MEDIUM; i++) {
      double y1 = math.min(
          _short, (WASHING_MEDIUM - i) / (WASHING_MEDIUM - WASHING_SHORT));
      double y2 = math.min(
          _medium, (i - WASHING_SHORT) / (WASHING_MEDIUM - WASHING_SHORT));
      _washingY[i] = math.max(y1, y2);
    }

    for (int i = WASHING_MEDIUM.toInt() + 1; i <= WASHING_LONG; i++) {
      double y1 = math.min(
          _medium, (WASHING_LONG - i) / (WASHING_LONG - WASHING_MEDIUM));
      double y2 = math.min(
          _long, (i - WASHING_MEDIUM) / (WASHING_LONG - WASHING_MEDIUM));
      _washingY[i] = math.max(y1, y2);
    }

    for (int i = WASHING_LONG.toInt() + 1; i <= WASHING_VERY_LONG; i++) {
      double y1 = math.min(
          _long, (WASHING_VERY_LONG - i) / (WASHING_VERY_LONG - WASHING_LONG));
      double y2 = math.min(
          _veryLong, (i - WASHING_LONG) / (WASHING_VERY_LONG - WASHING_LONG));
      _washingY[i] = math.max(y1, y2);
    }
  }

  void defuzzification() {
    double sum = 0, sumY = 0;
    for (int i = TIME_MIN; i <= TIME_MAX; i++) {
      sum += i * _washingY[i];
      sumY += _washingY[i];
    }
    print("(*): $sum\n(**): $sumY");
    time = sum / sumY;
  }

  double get getTime => this.time;
  double get getVeryShort => this._veryShort;
  double get getShort => this._short;
  double get getMedium => this._medium;
  double get getLong => this._long;
  double get getVeryLong => this._veryLong;

  @override
  String toString() {
    // TODO: implement toString
    return '$time';
  }
}
