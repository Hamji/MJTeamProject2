import 'dart:async';

import 'package:bitsync/data/data.dart';
import 'package:bitsync/services/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';

class InviteDialog {
  InviteDialog._();

  static void invite(
    final BuildContext context,
    final RoomData room,
  ) async {
    final progressDialog = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: true,
    );
    progressDialog.style(
      message: "Create invite url",
      borderRadius: 5.0,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      messageTextStyle: Theme.of(context).textTheme.bodyText1,
    );

    (() async => await progressDialog.show())();

    if (null == room.inviteUrl)
      room.inviteUrl =
          await DynamicLinkService.createRoomLink(roomId: room.roomId);

    progressDialog.update(message: "Share invite url");
    (() async {
      await Future.delayed(const Duration(seconds: 1));
      await progressDialog.hide();
    })();

    await Share.share(
      room.inviteUrl.toString(),
      subject: "Room ${room.roomId} invite url",
    );
  }
}

extension RoomInvite on RoomData {
  void invite(BuildContext context) => InviteDialog.invite(context, this);
}
