import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:bitsync/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DynamicLinkListener extends StatelessWidget {
  DynamicLinkListener({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: context.dynamicLinkBloc,
      builder: (context, state) {
        if (state is DynamicLinkStateNone)
          return onBuild(context);
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
          return onBuild(context);
        } else if (state is DynamicLinkStateInitial)
          context.dynamicLinkBloc.refresh();
        return LoadingPage();
      },
    );
  }

  Widget onBuild(BuildContext context);
}

class DynamicLinkRouter extends DynamicLinkListener {
  final Widget Function(BuildContext context) builder;

  DynamicLinkRouter({Key key, @required this.builder}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) => builder(context);
}
