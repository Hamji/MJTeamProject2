import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootPage extends StatelessWidget {
  final AuthBloc _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) => BlocProvider<AuthBloc>.value(
        value: _authBloc,
        child: BlocBuilder<AuthBloc, AuthState>(
          bloc: _authBloc,
          condition: (previous, current) => !previous.isSameAuthState(current),
          builder: (final context, final state) {
            if (state is AuthStateSignedOut)
              return LoginPage();
            else if (state is AuthStateError) {
              print(state.error);
              return LoginPage(
                  errorMessage: "Error to Login, Please try again.");
            } else if (state is AuthStateSignedIn)
              return MainPage();
            else if (state is AuthStateInitial)
              _authBloc.add(const AuthEventInitialize());

            return LoadingPage();
          },
        ),
      );
}
