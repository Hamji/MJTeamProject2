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

  @override
  void initState() {
    _onLoading = false;
    _appName = _buildNumber = _version = "Loading...";
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    final invListTile = (final String subtitle, final String title) => ListTile(
          title: Text(subtitle, style: theme.textTheme.caption),
          subtitle: Text(title, style: theme.textTheme.headline5),
        );

    _refresh(context);

    return MyScaffold(
      appBar: AppBar(
        title: const Text("Preference"),
      ),
      body: ListView(
        children: [
          invListTile("App name", _appName),
          invListTile("Version", _version),
          invListTile("Build number.", _buildNumber),
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
