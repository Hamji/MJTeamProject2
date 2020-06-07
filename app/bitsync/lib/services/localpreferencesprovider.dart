import 'package:bitsync/data/data.dart';
import 'package:bitsync/pages/loadingpage.dart';
import 'package:flutter/material.dart';

class LocalPreferencesProvider extends StatefulWidget {
  final Widget Function(BuildContext context, LocalPreferences preferences)
      builder;

  final bool useLoadingScreen;

  LocalPreferencesProvider({
    Key key,
    @required this.builder,
    this.useLoadingScreen = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LocalPreferencesProviderState();
}

class _LocalPreferencesProviderState extends State<LocalPreferencesProvider> {
  LocalPreferences preferences;

  @override
  void initState() {
    preferences = null;
    super.initState();
    loadPreferences();
  }

  void loadPreferences() async {
    var preferences = await LocalPreferences.getInstance();
    setState(() => this.preferences = preferences);
  }

  @override
  Widget build(BuildContext context) =>
      widget.useLoadingScreen && preferences == null
          ? LoadingPage()
          : widget.builder(context, preferences);
}
