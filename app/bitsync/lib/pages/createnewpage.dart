import 'package:bitsync/drawers/drawers.dart';
import 'package:bitsync/services/services.dart';
import 'package:bitsync/widgets/widgets.dart';
import "package:flutter/material.dart";
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class CreateRoomPage extends StatefulWidget {
  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoomPage> {
  @override
  File _roomPhoto;

  void onPhoto(ImageSource source) async {
    File f = await ImagePicker.pickImage(source: source);
    setState(()  => _roomPhoto = f);
  }


  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Create Room'),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(.0, 30.0, 0, 30.0),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                InkWell(
                    onTap: () =>
                    {
                      onPhoto(ImageSource.gallery),
                    },
                    child: CircleAvatar(
                      radius: 60.0,
                      backgroundColor: Colors.black12,
                      backgroundImage: FileImage(_roomPhoto),
                    )),
                Text(
                  'Room Name',
                  style: TextStyle(fontSize: 25.0),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Max User',
                      style: TextStyle(fontSize: 30.0),
                    ),
                    Text(
                      'Default Atority',
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                  ],
                )
              ],
            ),
            FloatingActionButton.extended(
              onPressed: () {},
              icon: Icon(Icons.save),
              label: Text('Determine'),
              backgroundColor: Colors.black54,
            ),
          ],
        ),

      ),

    );
  }
}