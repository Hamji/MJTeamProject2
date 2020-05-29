import 'package:bitsync/data/data.dart';
import 'package:bitsync/views/views.dart';
import 'package:bitsync/widgets/myscaffold.dart';
import 'package:flutter/material.dart';

class TouchAdjustPage extends StatefulWidget {
  @override
  State<TouchAdjustPage> createState() => _TouchAdjustPageState();
}

class _TouchAdjustPageState extends State<TouchAdjustPage> {
  int _detectedOffset;

  @override
  void initState() {
    _presetData.startAt = 0;
    _detectedOffset = 0;
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return MyScaffold(
      appBar: AppBar(title: const Text("Adjust touch time")),
      body: Stack(
        children: [
          SequenceView(roomData: _presetData),
          _detectTouch(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop<int>(context, _detectedOffset),
        child: const Icon(Icons.save),
        tooltip: "Apply",
      ),
      backgroundColor: Colors.black,
      setDefaultPadding: false,
    );
  }

  Widget _detectTouch(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text(
          "Tap to adjust touch time\nOffset: ${_detectedOffset ~/ 1000} ms",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 32.0,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          var touchTime = getTimestamp();

          int duration = _presetData.durationMicroseconds;
          int beatLength = duration ~/ _presetData.current.size;
          int inSeq = (touchTime - _presetData.startAt) % duration;

          int index =
              _presetData.getCurrentBeatIndex(touchTime, useRound: true);
          int target = beatLength * index;
          int offset = inSeq - target;
          setState(() => _detectedOffset = offset);
        },
      ),
      alignment: Alignment.center,
    );
  }
}

final RoomData _presetData = new RoomData(roomId: "touchAdjustSample")
  ..name = "Touch Adjust Sample"
  ..startAt = 0
  ..sequence = <Sequence>[
    Sequence(
      elements: [
        PatternElement(type: PatternType.large),
        PatternElement(type: PatternType.small),
        PatternElement(type: PatternType.medium),
        PatternElement(type: PatternType.small),
      ],
      size: 4,
      repeatCount: -1,
    )
  ]
  ..currentIndex = 0
  ..duration = 2.0;
