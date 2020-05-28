import 'package:bitsync/data/data.dart';
import 'package:bitsync/views/views.dart';
import 'package:flutter/material.dart';

class RoomView extends StatelessWidget {
  final RoomData roomData;

  RoomView({Key key, @required this.roomData}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Stack(
      children: [
        SequenceView(roomData: roomData),
        Center(
          child: BpmTapper(
            child: Text(
              roomData.current.bpm.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 96.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
