import 'package:bitsync/drawers/drawers.dart';
import 'package:bitsync/pages/createnewpage.dart';
import 'package:bitsync/pages/favoritspage.dart';
import 'package:bitsync/services/services.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  void test() async {
    var result = await ShortUrlService.makeShortUrl(
        "https://bitsync.page.link?amv=1&apn=com.quintet.BitSync&ibi=com.quintet.BitSync&imv=1.0.0&isi=&ipbi=com.quintet.BitSync&link=https%3A%2F%2Fbitsync.page.link%2Frooms%2F142274323");
    print(result);
  }

  @override
  Widget build(final BuildContext context) {
    test();
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
              onPressed: () async {
                final uri = await DynamicLinkService.createRoomLink(
                    roomId: "142274323");
                print(uri.toString());
              },
              icon: Icons.airplay,
              caption: "Enter Room",
            ),
            _menuItem(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritsPage()),
                );
              },
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
