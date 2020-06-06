import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:bitsync/pages/loadingpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthenticationRequiredPage extends StatelessWidget {
  AuthenticationRequiredPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder(
      bloc: context.authBloc,
      builder: (context, state) {
        if (state is AuthStateSignedIn)
          return onSignedIn(context, state.user);
        else
          return LoadingPage();
      });

  Widget onSignedIn(BuildContext context, User user);
}
