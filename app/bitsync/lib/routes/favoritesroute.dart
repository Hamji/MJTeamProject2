import 'package:bitsync/pages/favoritspage.dart';
import 'package:bitsync/routes/authbaseroute.dart';
import 'package:flutter/material.dart';

class FavoritesRoute extends AuthBaseRoute {
  FavoritesRoute(final RouteSettings settings)
      : super(
          settings: settings,
          builder: (context) => FavoritsPage(),
        );
}
