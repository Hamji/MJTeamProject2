import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:bitsync/pages/pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthBasedPage extends StatelessWidget {
  AuthBasedPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<AuthBloc, AuthState>(
        bloc: context.authBloc,
        condition: (previous, current) => !previous.isSameAuthState(current),
        builder: (final context, final state) {
          if (state is AuthStateSignedOut)
            return LoginPage();
          else if (state is AuthStateError) {
            print(state.error);
            return LoginPage(errorMessage: "Error to Login, Please try again.");
          } else if (state is AuthStateSignedIn)
            return onAuthenticated(context, state.user);
          else if (state is AuthStateInitial)
            context.authBloc.add(const AuthEventInitialize());

          return LoadingPage();
        },
      );

  Widget onAuthenticated(BuildContext context, User user);
}
