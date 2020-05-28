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
  Widget build(final BuildContext context) => LayoutBuilder(
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
      );

  @override
  void dispose() {
    controller.removeStatusListener(_onControllerStatus);
    animation.removeListener(_onAnimationListener);
    controller.dispose();
    super.dispose();
  }
}

const double _gridDashWidth = 7.0;
const double _gridDashSpace = 5.0;

class _BeatPainter extends CustomPainter {
  static final Paint _beatPaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 5.0;
  static final Paint _gridPaint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 1.0;
  static final Paint _boundaryPaint = Paint()
    ..color = Colors.grey
    ..strokeWidth = 1.0;

  final RoomData roomData;
  final int tick;

  _BeatPainter({@required this.roomData, @required this.tick});

  @override
  void paint(final Canvas canvas, final Size size) {
    canvas.save();
    var _latestUpdatedAt = timestamp;
    // elapsedAtStart: seconds
    var elapsedAtStart = (_latestUpdatedAt - roomData.startAt) * 1.0e-6;
    var cnt = elapsedAtStart / roomData.current.duration;
    var cDelta = cnt - cnt.floorToDouble();

    canvas.translate(size.width * 0.5, cDelta * size.height);
    for (var i = 0; i < 2; i++) {
      _drawPattern(canvas, size, roomData.current);
      canvas.drawLine(Offset(-size.width * 0.5, 0.0),
          Offset(size.width * 0.5, 0.0), _boundaryPaint);
      canvas.translate(0.0, -size.height);
    }
    canvas.restore();
  }

  void _drawPattern(
    final Canvas canvas,
    final Size size,
    final Pattern pattern,
  ) {
    final double h = size.height / pattern.size.toDouble();
    double y = size.height;
    final double width = size.width;
    final double half = width * 0.5;
    final double shalf = half * 0.8;

    _drawGridVertical(canvas, size.height, 0.0);
    _drawGridVertical(canvas, size.height, shalf * 0.75);
    _drawGridVertical(canvas, size.height, shalf * -0.75);
    _drawGridVertical(canvas, size.height, shalf * 0.5);
    _drawGridVertical(canvas, size.height, shalf * -0.5);

    for (var element in pattern.elements) {
      switch (element.type) {
        case PatternType.mute:
          _drawGridHorizontal(canvas, half, y);
          break;
        case PatternType.large:
          _drawGridHorizontal(canvas, half, y);
          canvas.drawLine(Offset(-shalf, y), Offset(shalf, y), _beatPaint);
          break;
        case PatternType.medium:
          _drawGridHorizontal(canvas, half, y);
          double dvt = shalf * 0.75;
          canvas.drawLine(Offset(-dvt, y), Offset(dvt, y), _beatPaint);
          break;
        case PatternType.small:
          _drawGridHorizontal(canvas, half, y);
          double dvt = shalf * 0.5;
          canvas.drawLine(Offset(-dvt, y), Offset(dvt, y), _beatPaint);
          break;
        case PatternType.subPattern:
          canvas.save();
          canvas.translate(0.0, y);
          _drawPattern(canvas, Size(width, h), element.subPattern);
          canvas.restore();
          break;
      }
      y -= h;
    }
  }

  void _drawGridHorizontal(
    final Canvas canvas,
    final double halfWidth,
    final double y,
  ) {
    double startX = -halfWidth;
    while (startX < halfWidth) {
      canvas.drawLine(
          Offset(startX, y), Offset(startX + _gridDashWidth, y), _gridPaint);
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
      canvas.drawLine(
          Offset(x, startY), Offset(x, startY + _gridDashWidth), _gridPaint);
      startY += _gridDashWidth + _gridDashSpace;
    }
  }

  @override
  bool shouldRepaint(final _BeatPainter oldDelegate) =>
      oldDelegate.tick != this.tick;

  int get timestamp => DateTime.now().microsecondsSinceEpoch;
}
