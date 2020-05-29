import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final String errorMessage;

  LoginPage({Key key, this.errorMessage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(final BuildContext context) => MyScaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              FlutterLogo(size: 150),
              widget.errorMessage == null
                  ? const SizedBox(height: 50)
                  : Padding(
                      child: Text(
                        widget.errorMessage,
                        style: TextStyle(color: Theme.of(context).errorColor),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
              _GoogleSignInButton(),
            ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      );
}

class _GoogleSignInButton extends StatelessWidget {
  @override
  Widget build(final BuildContext context) => OutlineButton(
        child: Padding(
          child: Row(
            children: <Widget>[
              Image(
                image: AssetImage("assets/images/logo_google.png"),
                height: 35.0,
              ),
              Padding(
                child: const Text(
                  "Sign in with Google",
                  style: const TextStyle(fontSize: 20, color: Colors.grey),
                ),
                padding: const EdgeInsets.only(left: 10),
              ),
            ],
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        ),
        splashColor: Colors.grey,
        onPressed: () =>
            context.authBloc.add(const AuthEventRequestSignInWithGoogle()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: const BorderSide(color: Colors.grey),
      );
}
