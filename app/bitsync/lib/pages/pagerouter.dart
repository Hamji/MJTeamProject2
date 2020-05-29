import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:bitsync/pages/loadingpage.dart';
import 'package:bitsync/pages/pages.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PageRouter extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return MyBlocProvider<DynamicLinkBloc, DynamicLinkState>.withBuilder(
      create: (_) => DynamicLinkBloc(),
      builder: (context, state) {
        if (state is DynamicLinkStateNone)
          return MainPage();
        else if (state is DynamicLinkStateUpdated) {
          print("============= ROOMID ${state.data.link.pathSegments[1]}");
          Navigator.pushNamed(
            context,
            state.data.link.pathSegments[0],
            arguments: RoomRouteParameters(
              parentContext: context,
              roomId: state.data.link.pathSegments[1],
            ),
          );
          return MainPage();
        } else if (state is DynamicLinkStateInitial)
          context.dynamicLinkBloc.refresh();
        return LoadingPage();
      },
    );
  }
}
