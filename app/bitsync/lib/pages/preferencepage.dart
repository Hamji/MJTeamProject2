import 'package:bitsync/data/data.dart';
import 'package:bitsync/pages/pages.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class PreferencePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  String _version = "Loading...";
  String _buildNumber = "Loading...";
  String _appName = "Loading...";

  LocalPreferences _preferences;
  int _updateTick;

  @override
  void initState() {
    _appName = _buildNumber = _version = "Loading...";
    _updateTick = 0;
    _loadAppInfo();
    LocalPreferences.getInstance()
        .then((value) => setState(() => _preferences = value));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    final invListTile = (final String subtitle, final Widget child) => ListTile(
          title: Text(subtitle, style: theme.textTheme.caption),
          subtitle: child,
        );

    final invListTileWithTitle = (final String subtitle, final String title) =>
        invListTile(subtitle, Text(title, style: theme.textTheme.headline5));

    return MyScaffold(
      appBar: AppBar(
        title: const Text("Preference"),
      ),
      body: ListView(
        children: [
          invListTile(
            "Touch time offset (milliseconds)",
            FlatButton.icon(
              onPressed: _preferences == null
                  ? null
                  : () async {
                      int result = await Navigator.push<int>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TouchAdjustPage(),
                        ),
                      );
                      if (null != result) {
                        await _preferences.setOffsetOfTouchTimestamp(result);
                        _refresh();
                      }
                    },
              icon: const Icon(Icons.timer),
              label: Text(_preferences == null
                  ? "Loading..."
                  : "${_preferences.offsetOfTouchTimestampMilliseconds} ms"),
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

  void _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();

    setState(() {
      _appName = info.appName;
      _version = info.version;
      _buildNumber = info.buildNumber;
    });
  }

  void _refresh() => setState(() => ++_updateTick);
}
