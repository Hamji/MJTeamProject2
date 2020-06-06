import 'dart:io';
import 'dart:math';

import 'package:bitsync/data/data.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';

final databaseReference = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

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

  bool showDocument(String documentID) {
    final result = Firestore.instance
        .collection('rooms')
        .document(documentID)
        .get();

    if(result == null)
      return false;
    else
      return true;
  }

  String makeRoom(){
    String result = "";
    int rand = Random().nextInt(9);
    do{
      result ="";
      for(int i = 0; i < 9; i++){
        result += rand.toString();
      }
    }while(!showDocument(result));
    return result;
  }
  // DB에 룸 생성
  void createRecord() async {
    if (roomNameController.text == "")
      _roomData.name = "Room Name";
    else
      _roomData.name = roomNameController.text;

    _roomData.password = passwordController.text;

    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    _roomData.master = uid.toString();

    int rand = 0;
    String roomNo = "";

    for(int i = 0; i < 9; i++){
      rand = Random().nextInt(9);
      roomNo += rand.toString();
    }

    await databaseReference.collection("rooms")
        .document(roomNo)
        .setData(_roomData.toMap());


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
          // Row(
          //   children: <Widget>[
          //     // 설정부분 텍스트
          //     Column(
          //       children: <Widget>[
          //         SizedBox(
          //           height: 9.0,
          //         ),
          //         Text(
          //           'Default Authority',
          //           style: TextStyle(fontSize: 30.0),
          //         ),
          //       ],
          //     ),
          //     // 설정
          //     Column(
          //       children: <Widget>[
          //         DropdownButton<String>(
          //           value: _roomData.authority,
          //           hint: Text('Select Max User'),
          //           underline: Container(
          //             height: 2,
          //             color: Colors.black,
          //           ),
          //           onChanged: (String newValue) {
          //             setState(() {
          //               _roomData.authority = newValue;
          //             });
          //           },
          //           items: <String>['read only', 'read write']
          //               .map<DropdownMenuItem<String>>((String value) {
          //             return DropdownMenuItem<String>(
          //               value: value,
          //               child: Text(value),
          //             );
          //           }).toList(),
          //         ),
          //       ],
          //     )
          //   ],
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // ),
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
