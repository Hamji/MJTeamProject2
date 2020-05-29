import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/pages/pages.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MyBlocProvider.withBuilder(
        create: (context) => AuthBloc(),
        condition: (previous, current) => !previous.isSameAuthState(current),
        builder: (final context, final state) {
          if (state is AuthStateSignedOut)
            return LoginPage();
          else if (state is AuthStateError) {
            print(state.error);
            return LoginPage(errorMessage: "Error to Login, Please try again.");
          } else if (state is AuthStateSignedIn)
            return PageRouter();
          else if (state is AuthStateInitial)
            context.authBloc.add(const AuthEventInitialize());

          return LoadingPage();
        },
      );
}
