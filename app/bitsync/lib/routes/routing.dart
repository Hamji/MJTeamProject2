import 'package:bitsync/data/data.dart';
import 'package:bitsync/routes/routes.dart';
import 'package:flutter/widgets.dart';

final _routes = {
  ROUTE_MY_PROFILE: (settings) => MyProfileRoute(settings),
  ROUTE_PREFERENCE: (settings) => PreferenceRoute(settings),
  ROUTE_FAVORITES: (settings) => FavoritesRoute(settings),
  ROUTE_ROOM: (settings) => RoomRoute(settings),
  ROUTE_MY_ROOM: (settings) => MyRoomRoute(settings),
  ROUTE_ROOT: (_) => RootRoute(),
};

class Routing {
  Routing._();

  static void toRoom(
    BuildContext context, {
    @required String roomId,
    bool createIfNotExist = false,
  }) =>
      Navigator.pushNamed(
        context,
        ROUTE_ROOM,
        arguments: RoomRouteParameters(
          parentContext: context,
          roomId: roomId,
          createIfNotExist: createIfNotExist,
        ),
      );

  static void toMyRoom(BuildContext context, {@required User user}) =>
      Navigator.pushNamed(
        context,
        ROUTE_ROOM,
        arguments: RoomRouteParameters(
          parentContext: context,
          roomId: user.myRoomID,
          createIfNotExist: true,
        ),
      );

  static void toFavorites(BuildContext context) =>
      Navigator.pushNamed(context, ROUTE_FAVORITES, arguments: context);

  static void toMyProfile(BuildContext context) =>
      Navigator.pushNamed(context, ROUTE_MY_PROFILE, arguments: context);

  static void toPreference(BuildContext context) =>
      Navigator.pushNamed(context, ROUTE_PREFERENCE, arguments: context);

  static Route<dynamic> onGenerateRoute(RouteSettings settings) =>
      (_routes[settings.name] ?? _routes["/"])(settings);
}
