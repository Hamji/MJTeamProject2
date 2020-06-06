import 'package:bitsync/data/data.dart';
import 'package:bitsync/drawers/drawers.dart';
import 'package:bitsync/pages/authbasedpage.dart';
import 'package:bitsync/routes/routes.dart';
import 'package:bitsync/views/views.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import 'createnewpage.dart';

class MainPage extends AuthBasedPage {
  MainPage({Key key}) : super(key: key);

  @override
  Widget onAuthenticated(BuildContext context, User user) => _HomePage(user);
}

class _HomePage extends StatefulWidget {
  final User user;
  _HomePage(this.user);
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  @override
  void initState() {
    initDynamicLink();
    super.initState();
  }

  void initDynamicLink() async {
    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    onLink(deepLink);
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (dynamicLink) async => onLink(dynamicLink?.link),
        onError: (OnLinkErrorException e) async {
          print('onLinkError');
          print(e.message);
        });
  }

  void onLink(Uri link) {
    if (null != link) {
      if (link.pathSegments[0] == ROUTE_ROOM)
        print("============= ROOMID ${link.pathSegments[1]}");

      Routing.toRoom(context, roomId: link.pathSegments[1]);
    }
  }

  @override
  Widget build(BuildContext context) => MyScaffold(
        appBar: AppBar(title: const Text("BitSync")),
        drawer: MainDrawer(),
        body: Center(
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: <Widget>[
              _menuItem(
                onPressed: () => Routing.toRoom(
                  context,
                  roomId: "142274323",
                  createIfNotExist: true,
                ),
                icon: Icons.grid_on,
                caption: "Enter test room", //  "Manage Beats",
              ),
               _menuItem(
                 onPressed: () {
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => CreateRoomPage()),
                   );
                 },
                 icon: Icons.create_new_folder,
                 caption: "Create New",
               ),
              _menuItem(
                onPressed: () => Routing.toMyRoom(context, user: widget.user),
                icon: Icons.home,
                caption: "Enter my room",
              ),
              _menuItem(
                onPressed: () async {
                  final String roomId = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectRoomDialog(),
                      ));
                  if (null != roomId)
                    Routing.toRoom(
                      context,
                      roomId: roomId,
                      createIfNotExist: false,
                    );
                },
                icon: Icons.airplay,
                caption: "Enter Room",
              ),
              _menuItem(
                onPressed: () => Routing.toFavorites(context),
                icon: Icons.star,
                caption: "Favorits",
              ),
            ],
          ),
        ),
      );
}

Widget _menuItem({
  final IconData icon,
  final String caption,
  final VoidCallback onPressed,
}) =>
    SizedBox(
      child: IconButtonWithCaption(
        icon: Icon(icon, size: 48),
        caption: caption,
        onPressed: onPressed,
      ),
      width: 128,
      height: 128,
    );
