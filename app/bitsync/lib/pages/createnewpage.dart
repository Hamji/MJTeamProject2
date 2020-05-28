import 'package:bitsync/data/data.dart';
import 'package:bitsync/drawers/drawers.dart';
import 'package:bitsync/services/services.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final databaseReference = Firestore.instance;



class CreateRoomPage extends StatefulWidget {
  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoomPage> {
  @override
  File _roomPhoto = File('assets/images/defalut_image.jpg');

  RoomData _roomData = new RoomData();

  final passwordController = TextEditingController();
  TextEditingController roomNameController = TextEditingController();

  void onPhoto(ImageSource source) async {
    File f = await ImagePicker.pickImage(source: source);
    // 이미지 파일을 선택하면 _roomPhoto = f
    if (f != null) setState(() => _roomPhoto = f);
  }

  // DB에 룸 생성
  void createRecord() async {
    if (roomNameController.text == "")
      _roomData.name = "Room Name";
    else
      _roomData.name = roomNameController.text;

    _roomData.password = passwordController.text;
    //.master = FirebaseAuth.instance.toString();

    DocumentReference ref = await databaseReference.collection("room").add({
      'name' : _roomData.name,
      'password' : _roomData.password,
      'max' : _roomData.max,
      'authority' : _roomData.authority,
      //master' : _roomData.master
    });
  }

  Widget build(BuildContext context) {
    return MyScaffold(
        appBar: AppBar(
          title: Text('Create Room'),
        ),
        resizeToAvoidBottomPadding: false,
        body: _body());
  }

// body 부분
  _body() {
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
              SizedBox(
                height: 9.0,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Room Name',
                ),
                controller: roomNameController,
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
                    'Default Authority',
                    style: TextStyle(fontSize: 30.0),
                  ),
                ],
              ),
              // 설정
              Column(
                children: <Widget>[
                  DropdownButton<int>(
                    value: _roomData.max,
                    hint: Text('Select Max User'),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (int newValue) {
                      setState(() {
                        _roomData.max = newValue;
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
                    value: _roomData.authority,
                    hint: Text('Select Max User'),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        _roomData.authority = newValue;
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
            controller: passwordController,
          ),
          SizedBox(
            height: 90.0,
          ),
          //결정버튼
          FloatingActionButton.extended(
            onPressed: () {
              createRecord();
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
