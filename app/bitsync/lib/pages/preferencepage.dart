import 'dart:math';

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

  double beepSoundDelay;
  double bpmDragScale;

  @override
  void initState() {
    _appName = _buildNumber = _version = "Loading...";
    _updateTick = 0;
    _loadAppInfo();
    LocalPreferences.getInstance().then((value) => setState(() {
          _preferences = value;
          beepSoundDelay =
              min(max(-200.0, _preferences.beepSoundDelay * 0.001), 200.0);
          bpmDragScale = _preferences.dragBPMscale * 5.0;
        }));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    if (null == _preferences) return LoadingPage();

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
          ListTile(
            onTap: () async {
              if (await _preferences
                  .setUseBeepSound(!_preferences.useBeepSound)) _refresh();
            },
            title: _preferences.useBeepSound
                ? const Text("Beep Sound: On")
                : const Text("Beep Sound: Mute"),
            leading: _preferences.useBeepSound
                ? const Icon(Icons.volume_up)
                : const Icon(Icons.volume_off),
          ),
          invListTile(
            "Beep sound delay: ${beepSoundDelay.toStringAsFixed(0)} ms",
            Slider(
              onChanged: _preferences.useBeepSound
                  ? (value) => setState(() => beepSoundDelay = value)
                  : null,
              onChangeEnd: (value) async {
                await _preferences.setBeepSoundDelay((value * 1000.0).floor());
                setState(() => beepSoundDelay = value);
              },
              value: beepSoundDelay,
              max: 200.0,
              min: -200.0,
            ),
          ),
          invListTile(
            "Touch time offset (milliseconds)",
            FlatButton.icon(
              onPressed: () async {
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
              label:
                  Text("${_preferences.offsetOfTouchTimestampMilliseconds} ms"),
            ),
          ),
          invListTile(
            "Modify BPM by dragging",
            FlatButton.icon(
              onPressed: () async {
                await _preferences.setUseBPMdrag(!_preferences.useBPMdrag);
                _refresh();
              },
              icon: _preferences.useBPMdrag
                  ? const Icon(Icons.radio_button_checked)
                  : const Icon(Icons.radio_button_unchecked),
              label: _preferences.useBPMdrag
                  ? const Text("Drag BPM: On")
                  : const Text("Drag BPM: Off"),
            ),
          ),
          invListTile(
            "BPM dragging scale: ${bpmDragScale.toStringAsFixed(0)}",
            Slider(
              onChanged: (value) => setState(() => bpmDragScale = value),
              onChangeEnd: _preferences.useBPMdrag
                  ? (value) async {
                      await _preferences.setDragBPMscale(value * 0.2);
                      setState(() => bpmDragScale = value);
                    }
                  : null,
              value: bpmDragScale,
              // label: _preferences.dragBPMscale.toString(),
              // divisions: 19,
              max: 10.0,
              min: 0.5,
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
