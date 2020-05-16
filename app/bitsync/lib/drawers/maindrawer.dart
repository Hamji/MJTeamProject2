import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/routes/routes.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainDrawer extends StatelessWidget {
  MainDrawer({Key key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: BlocBuilder<AuthBloc, AuthState>(
                bloc: BlocProvider.of<AuthBloc>(context),
                builder: (context, state) => state is AuthStateSignedIn
                    ? Column(
                        children: <Widget>[
                          MyAvata(state.user, maxRadius: 36),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            state.user.nickname,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      )
                    : Column(
                        children: [const CircularProgressIndicator()],
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text("My Profile"),
              onTap: () => Routing.toMyProfile(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Preference"),
              onTap: () => Routing.toPreference(context),
            ),
          ],
          padding: EdgeInsets.zero,
        ),
      );
}
