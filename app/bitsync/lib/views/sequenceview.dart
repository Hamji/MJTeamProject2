import 'package:bitsync/data/data.dart';
import 'package:flutter/material.dart';

class SequenceView extends StatefulWidget {
  final RoomData roomData;

  SequenceView({Key key, @required this.roomData}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SequenceViewState();
}

class _SignalAnimate extends Animatable<int> {
  int current = 0;
  @override
  int transform(double t) => ++current;
}

class _SequenceViewState extends State<SequenceView>
    with SingleTickerProviderStateMixin {
  RoomData get roomData => widget.roomData;

  AnimationController controller;
  Animation<int> animation;
  int tick = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..addStatusListener(_onControllerStatus);
    animation = _SignalAnimate().animate(controller)
      ..addListener(_onAnimationListener);
    controller.forward();
  }

  _onAnimationListener() => setState(() => tick = animation.value);

  _onControllerStatus(final AnimationStatus status) {
    if (status == AnimationStatus.completed)
      controller.reset();
    else if (status == AnimationStatus.dismissed) controller.forward();
  }

  @override
  Widget build(final BuildContext context) => Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) => Container(
              child: CustomPaint(
                painter: _BeatPainter(
                  roomData: roomData,
                  tick: tick,
                ),
              ),
              width: constraints.maxWidth,
              height: constraints.maxHeight,
            ),
          ),
          Text(
            "${roomData.currentBeatIndex + 1} / ${roomData.current.size}\nstartAt: ${roomData.startAt}\nduration: ${roomData.duration}",
            style: const TextStyle(color: Colors.white),
          )
        ],
      );

  @override
  void dispose() {
    controller.removeStatusListener(_onControllerStatus);
    animation.removeListener(_onAnimationListener);
    controller.dispose();
    super.dispose();
  }
}

class _BeatPainter extends CustomPainter {
  static const double _gridDashWidth = 7.0;
  static const double _gridDashSpace = 5.0;
  static const double _mediumBeatWidth = 0.667;
  static const double _smallBeatWidth = 0.333;
  static const Color _gridColor = Colors.grey;

  static final Paint _beatPaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 5.0
    ..strokeCap = StrokeCap.round;
  static final Paint _gridPaint = Paint()
    ..color = _gridColor
    ..strokeWidth = 1.0
    ..blendMode = BlendMode.lighten;
  static final Paint _boundaryPaint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 1.0;

  static final Paint _blurPaint = Paint()..blendMode = BlendMode.darken;
  static final Gradient _blurGradient = LinearGradient(
    colors: [
      Colors.white,
      Color.lerp(Colors.white, Colors.black, 0.5),
      Colors.black,
    ],
    stops: [0.0, 0.2, 1.0],
    begin: const Alignment(0.0, 0.0),
    end: const Alignment(0.0, 1.0),
  );

  final RoomData roomData;
  final int tick;

  double half;
  double shalf;

  _BeatPainter({@required this.roomData, @required this.tick});

  @override
  void paint(final Canvas canvas, final Size size) {
    half = size.width * 0.5;
    shalf = half * 0.8;

    canvas.save();
    var _latestUpdatedAt = getTimestamp();
    int duration = roomData.durationMicroseconds;
    int pass = (_latestUpdatedAt - roomData.startAt) % duration;

    canvas.translate(size.width * 0.5, 0.0);
    canvas.scale(1.0, 0.8);
    canvas.translate(0.0, (pass / duration + 1.0) * size.height);
    for (var i = 0; i < 3; i++) {
      _drawPattern(canvas, size, roomData.current, 0);
      canvas.drawLine(Offset(-size.width * 0.5, 0.0),
          Offset(size.width * 0.5, 0.0), _boundaryPaint);
      canvas.translate(0.0, -size.height);
    }
    canvas.restore();

    /// draw flash light
    PatternType beatType;
    Pattern pattern = roomData.current;
    double beatElapsed;

    for (;;) {
      int beatLength = duration ~/ pattern.size;
      int index = pass ~/ beatLength;
      var beat = pattern[index % pattern.size];
      beatType = beat.type;
      if (beatType == PatternType.subPattern) {
        pass %= beatLength;
        duration = beatLength;
        pattern = beat.subPattern;
      } else {
        beatElapsed = pass % beatLength * 1e-6;
        break;
      }
    }

    double lightPower;
    double lightDuration;

    switch (beatType) {
      case PatternType.large:
        lightPower = 1.0;
        lightDuration = 0.5;
        break;
      case PatternType.medium:
        lightPower = 0.7;
        lightDuration = 0.3;
        break;
      case PatternType.small:
        lightPower = 0.4;
        lightDuration = 0.2;
        break;
      default:
        lightDuration = 0.0;
    }

    double scale = (roomData.duration / roomData.current.size);
    if (scale < 1.0) lightDuration *= scale;
    if (lightDuration > beatElapsed)
      lightPower *= (lightDuration - beatElapsed) / lightDuration;
    else
      lightPower = 0.0;

    // draw dead line
    canvas.save();
    canvas.translate(0.0, size.height * 0.8);
    canvas.scale(size.width, 1.0);
    var rect = Rect.fromLTWH(0, 0, 1, size.height * 0.2);
    _blurPaint.shader = _blurGradient.createShader(rect);
    canvas.drawRect(rect, _blurPaint);
    canvas.drawLine(
      Offset.zero,
      const Offset(1.0, 0.0),
      _gridPaint,
    );
    if (lightPower > 0.0) {
      canvas.scale(1.0, lightPower * 5.0 + 2.0);
      canvas.drawLine(
        Offset.zero,
        const Offset(1.0, 0.0),
        _getLightPaint(lightPower * 3.0),
      );
    }
    canvas.restore();

    canvas.save();
    canvas.translate(half, 0.0);
    _drawGridVertical(canvas, size.height, 0.0);
    _drawGridVertical(canvas, size.height, shalf * _mediumBeatWidth);
    _drawGridVertical(canvas, size.height, shalf * -_mediumBeatWidth);
    _drawGridVertical(canvas, size.height, shalf * _smallBeatWidth);
    _drawGridVertical(canvas, size.height, shalf * -_smallBeatWidth);

    if (lightPower > 0.0) {
      canvas.scale(size.width, size.height);
      canvas.drawRect(
        const Rect.fromLTWH(-0.5, 0.0, 1.0, 1.0),
        _getLightPaint(lightPower),
      );
    }

    canvas.restore();
  }

  static final _lightColorCache = Map<int, Color>();
  static final _lightPaint = Paint()
    ..blendMode = BlendMode.lighten
    ..strokeWidth = 1.0;
  static Paint _getLightPaint(double lightPower) {
    lightPower = lightPower.clamp(0.0, 1.0);
    int index = (lightPower * 255).round();
    if (_lightColorCache.containsKey(index))
      return _lightPaint..color = _lightColorCache[index];
    else
      return _lightPaint
        ..color = _lightColorCache[index] =
            Color.lerp(Colors.black, Colors.white, lightPower);
  }

  void _drawPattern(
    final Canvas canvas,
    final Size size,
    final Pattern pattern,
    final int depth,
  ) {
    final double h = size.height / pattern.size.toDouble();
    double y = size.height;

    double gridOpacity = 1.0;

    for (int i = 0; i < pattern.size; i++) {
      var element = pattern[i];
      switch (element.type) {
        case PatternType.mute:
          _drawGridHorizontal(canvas, half, y, gridOpacity);
          break;
        case PatternType.large:
          _drawGridHorizontal(canvas, half, y, gridOpacity);
          canvas.drawLine(Offset(-shalf, y), Offset(shalf, y), _beatPaint);
          break;
        case PatternType.medium:
          _drawGridHorizontal(canvas, half, y, gridOpacity);
          double dvt = shalf * _mediumBeatWidth;
          canvas.drawLine(Offset(-dvt, y), Offset(dvt, y), _beatPaint);
          break;
        case PatternType.small:
          _drawGridHorizontal(canvas, half, y, gridOpacity);
          double dvt = shalf * _smallBeatWidth;
          canvas.drawLine(Offset(-dvt, y), Offset(dvt, y), _beatPaint);
          break;
        case PatternType.subPattern:
          canvas.save();
          canvas.translate(0.0, y - h);
          _drawPattern(
              canvas, Size(size.width, h), element.subPattern, depth + 1);
          canvas.restore();
          break;
      }
      if (depth > 0) gridOpacity = 0.5;
      y -= h;
    }
  }

  static final Map<int, Color> _gridColorAlphaMap = {255: _gridColor};
  static Paint _getGridPaint(double opacity) {
    int alpha = (opacity * 255.0).round();
    if (_gridColorAlphaMap.containsKey(alpha))
      _gridPaint..color = _gridColorAlphaMap[alpha];
    else {
      _gridPaint
        ..color = _gridColorAlphaMap[alpha] = _gridColor.withAlpha(alpha);
    }
    return _gridPaint;
  }

  void _drawGridHorizontal(
    final Canvas canvas,
    final double halfWidth,
    final double y,
    final double opacity,
  ) {
    double startX = -halfWidth;
    while (startX < halfWidth) {
      canvas.drawLine(Offset(startX, y), Offset(startX + _gridDashWidth, y),
          _getGridPaint(opacity));
      startX += _gridDashWidth + _gridDashSpace;
    }
  }

  void _drawGridVertical(
    final Canvas canvas,
    final double height,
    final double x,
  ) {
    double startY = 0.0;
    while (startY < height) {
      canvas.drawLine(Offset(x, startY), Offset(x, startY + _gridDashWidth),
          _gridPaint..color = _gridColor);
      startY += _gridDashWidth + _gridDashSpace;
    }
  }

  @override
  bool shouldRepaint(final _BeatPainter oldDelegate) =>
      oldDelegate.tick != this.tick;
}
