import 'package:bitsync/data/data.dart';
import 'package:bitsync/pages/pages.dart';
import 'package:bitsync/settings.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class PreferencePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  bool _onLoading;
  String _version;
  String _buildNumber;
  String _appName;

  int _touchTimeOffset = INITIAL_OFFSET_OF_TOUCH_TIMESTAMP;

  @override
  void initState() {
    _onLoading = false;
    _appName = _buildNumber = _version = "Loading...";
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    LocalPreferences.offsetOfTouchTimestamp().then((value) {
      if (_touchTimeOffset != value) setState(() => _touchTimeOffset = value);
    });

    final invListTile = (final String subtitle, final Widget child) => ListTile(
          title: Text(subtitle, style: theme.textTheme.caption),
          subtitle: child,
        );

    final invListTileWithTitle = (final String subtitle, final String title) =>
        invListTile(subtitle, Text(title, style: theme.textTheme.headline5));

    _refresh(context);

    return MyScaffold(
      appBar: AppBar(
        title: const Text("Preference"),
      ),
      body: ListView(
        children: [
          invListTile(
            "Touch time offset (milliseconds)",
            FlatButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TouchAdjustPage(),
                ),
              ),
              icon: const Icon(Icons.timer),
              label: Text("${_touchTimeOffset ~/ 1000} ms"),
            ),
          ),
          const Divider(),
          invListTileWithTitle("App name", _appName),
          invListTileWithTitle("Version", _version),
          invListTileWithTitle("Build number.", _buildNumber),
        ],
      ),
    );
  }

  void _refresh(final BuildContext context) async {
    if (_onLoading) return;
    _onLoading = true;
    final info = await PackageInfo.fromPlatform();

    setState(() {
      _appName = info.appName;
      _version = info.version;
      _buildNumber = info.buildNumber;
    });
  }
}
