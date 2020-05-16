import 'package:bitsync/drawers/drawers.dart';
import 'package:bitsync/services/services.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreateRoomPage extends StatefulWidget {
  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoomPage> {
  @override
  File _roomPhoto = File('assets/images/defalut_image.jpg');

  int _max = 1;
  String _roomAuthority = 'read only';
  String _roomPassword = '';
  void onPhoto(ImageSource source) async {
    File f = await ImagePicker.pickImage(source: source);
    // 이미지 파일을 선택하면 _roomPhoto = f
    if(f != null)
      setState(() => _roomPhoto = f);
  }

  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Create Room'),
      ),
      resizeToAvoidBottomPadding: false,
      body: _body()
    );
  }
// body 부분
  _body(){
      return Container(
        padding: const EdgeInsets.fromLTRB(.0, 30.0, 0, 30.0),
        child: Column(
          children: <Widget>[
            // 프로필 사진 부분
            Column(
              children: <Widget>[
                InkWell(
                    onTap: () {
                      onPhoto(ImageSource.gallery);
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
            // 설정 부분
            Row(
              children: <Widget>[
                // 설정부분 텍스트
                Column(
                  children: <Widget>[
                    Text(
                      'Max User',
                      style: TextStyle(fontSize: 30.0),
                    ),
                    SizedBox(
                      height: 9.0,
                    ),
                    Text(
                      'Default Atority',
                      style: TextStyle(fontSize: 30.0),
                    ),

                  ],
                ),
                // 설정
                Column(
                  children: <Widget>[
                    DropdownButton<int>(
                      value: _max,
                      hint: Text('Select Max User'),
                      underline: Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      onChanged: (int newValue) {
                        setState(() {
                          _max = newValue;
                        });
                      },
                      items: <int>[1, 2, 3, 4]
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                    DropdownButton<String>(
                      value: _roomAuthority,
                      hint: Text('Select Max User'),
                      underline: Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          _roomAuthority = newValue;
                        });
                      },
                      items: <String>['read only', 'read write']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            SizedBox(
              height: 90.0,
            ),
            //결정버튼
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.pop(context);

              },
              icon: Icon(Icons.save),
              label: Text('Determine'),
              backgroundColor: Colors.black54,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      );
  }
}
