import 'package:bitsync/drawers/drawers.dart';
import 'package:bitsync/pages/createnewpage.dart';
import 'package:bitsync/pages/favoritspage.dart';
import 'package:bitsync/services/services.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class UserAuthority extends StatefulWidget {
  @override
  _UserAuthority createState() => _UserAuthority();
}
class _UserAuthority extends State<UserAuthority> {
  @override
  BuildContext ctx;
  String _target = "";
  String _truetarget = "";
  List<String> _roomAuthority = ['read only', 'read only', 'read only', 'read only'];
  List<String> _nickname = ['gunny', 'donge', 'zZangsun', 'winfire'];
  //assets/images/default_image.jpg
  File _roomPhoto = File('assets/images/logo_google.png');
  void onPhoto(ImageSource source) async {
    File f = await ImagePicker.pickImage(source: source);
    // 이미지 파일을 선택하면 _roomPhoto = f
    if(f != null)
      setState(() => _roomPhoto = f);
  }
  Widget build(BuildContext context) {
    ctx = context;
    int _max = 1;

    return MyScaffold(
      appBar: AppBar(title: const Text("User Authority")),
      //drawer: MainDrawer(),
      resizeToAvoidBottomPadding: false,
      body: _body(),
    );
  }
  _body(){
    return Container(
      //padding: const EdgeInsets.fromLTRB(.0, 30.0, 0, 30.0),
      child: Column(
          children: <Widget>[
            Container(
            child:Text(
                'user search',
                  style: TextStyle(fontSize: 20.0),
                  
              ),
            ),
            Divider(color: Colors.black,
            height: 10,
            thickness: 5,
            indent: 0,
            endIndent: 0,),
            Row(
              children: <Widget>[
                new Flexible(
              child: new TextField(
              decoration: const InputDecoration(labelText: 'search'),
              style: Theme.of(context).textTheme.bodyText1,
              onChanged: (text){
                _target = text;
              },
            ),
                ),
                _search(
              onPressed: (){
                        setState(() {
                         _truetarget = _target;
                        });
                      },
              icon: Icons.search,
            ),
              ],

            ),
            Divider(color: Colors.black,
            height: 10,
            thickness: 5,
            indent: 0,
            endIndent: 0,),
            Text(
                'list',
                  style: TextStyle(fontSize: 20.0),
              ),
            Divider(color: Colors.black,
            height: 10,
            thickness: 5,
            indent: 0,
            endIndent: 0,),
              _searchlist(0,_truetarget),
              _searchlist(1,_truetarget),
              _searchlist(2,_truetarget),
              _searchlist(3,_truetarget),
          ],

      ),
    );
  }
    Widget _search({
    final IconData icon,
    final String caption,
    final VoidCallback onPressed,
  }) =>
      SizedBox(
        child: IconButtonWithCaption(
          icon: Icon(icon, size: 32),
          caption: caption,
          onPressed: onPressed,
        ),
        width: 64,
        height: 64,
      );
_searchlist(int i,String s){
  //print("")
  if(_nickname[i].length==_nickname[i].replaceAll(s,"").length && s != ""){
    return Container();
  }else{
    return Container(
      //padding: const EdgeInsets.fromLTRB(.0, 30.0, 0, 30.0),
      child: Row(
          children: <Widget>[
            InkWell(
                    onTap: () {
                      onPhoto(ImageSource.gallery);
                    },
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.black12,
                      backgroundImage: FileImage(_roomPhoto),
                    )),
            Text(
                '  '+_nickname[i]+'  ',
                  style: TextStyle(fontSize: 20.0),
              ),
              DropdownButton<String>(
                      value: _roomAuthority[i],
                      hint: Text(_roomAuthority[i]),
                      underline: Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          _roomAuthority[i] = newValue;
                          
                        });
                      },
                      items: <String>['read only', 'read write']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      );
  }
}
}
