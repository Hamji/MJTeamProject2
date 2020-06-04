import 'package:bitsync/drawers/drawers.dart';
import 'package:bitsync/pages/createnewpage.dart';
import 'package:bitsync/routes/routes.dart';
import 'package:bitsync/views/views.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return MyScaffold(
      appBar: AppBar(title: const Text("BitSync")),
      drawer: MainDrawer(),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: <Widget>[
            _menuItem(
              onPressed: null,
              icon: Icons.grid_on,
              caption: "Manage Beats",
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
              // onPressed: () => Routing.toRoom(
              //   context,
              //   roomId: "142274323",
              //   createIfNotExist: true,
              // ),
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
}
