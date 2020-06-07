import 'package:bitsync/data/data.dart';
import 'package:bitsync/services/services.dart';
import 'package:bitsync/views/views.dart';
import 'package:flutter/material.dart';

class RoomView extends StatelessWidget {
  final RoomData roomData;
  final bool canEdit;
  final BeepPlayer beepPlayer;

  RoomView({
    Key key,
    @required this.roomData,
    @required this.canEdit,
    this.beepPlayer,
  }) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Stack(
      children: [
        SequenceView(
          roomData: roomData,
          beepPlayer: beepPlayer,
        ),
        Center(
          child: BpmTapper(
            roomData: roomData,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 96.0,
              fontWeight: FontWeight.bold,
            ),
            enabled: canEdit,
          ),
        ),
      ],
    );
  }
}
