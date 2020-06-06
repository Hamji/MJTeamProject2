import 'package:bitsync/data/user.dart';
import 'package:bitsync/pages/authbasedpage.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/material.dart';

final List<String> entries = <String>[];

class FavoritsPage extends AuthBasedPage {
  _body() {
    if (entries.length != 0)
      return ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Colors.black12,
            child: Center(child: Text('Entry ${entries[index]}')),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      );
    else
      return Center(
        child: Text(
          'Favorits is empty.',
          style: TextStyle(fontSize: 24.0, color: Colors.grey),
        ),
      );
  }

  @override
  Widget onAuthenticated(BuildContext context, User user) => MyScaffold(
        appBar: AppBar(title: const Text("Favorits")),
        body: _body(),
      );
}
