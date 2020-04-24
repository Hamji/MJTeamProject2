import 'dart:io';

import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:bitsync/pages/pages.dart';
import 'package:bitsync/settings.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: BlocProvider.of<AuthBloc>(context),
      builder: (final context, final state) {
        if (state is AuthStateSignedIn)
          return _viewPage(context, state.user);
        else
          return LoadingPage();
      },
    );
  }

  void _signOut(final BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
    BlocProvider.of<AuthBloc>(context).add(const AuthEventRequestSignOut());
  }

  Widget _viewPage(final BuildContext context, final User user) => Scaffold(
        appBar: AppBar(title: const Text("My Profile")),
        body: Center(
          child: Column(
            children: <Widget>[
              MyAvata(user, maxRadius: 48),
              const SizedBox(height: 24),
              Text(user.nickname, style: Theme.of(context).textTheme.headline5),
              SizedBox(height: 20),
              FlatButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<AuthBloc>(context),
                      child: _MyProfileEditPage(user: user),
                    ),
                  ),
                ),
                icon: const Icon(Icons.edit),
                label: const Text("Edit"),
              ),
              FlatButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Sign-out"),
                    content: const Text(
                        "Are you sure you want to sign out? You cannot use the app until you sign in again."),
                    actions: <Widget>[
                      FlatButton.icon(
                          onPressed: () => _signOut(context),
                          icon: const Icon(Icons.exit_to_app),
                          label: const Text("Sign-out")),
                      FlatButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.cancel),
                          label: const Text("Cancel")),
                    ],
                  ),
                ),
                icon: const Icon(Icons.exit_to_app),
                label: const Text("Sign out"),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      );
}

class _MyProfileEditPage extends StatefulWidget {
  final User user;
  _MyProfileEditPage({@required this.user});
  @override
  State<StatefulWidget> createState() => _MyProfileEditPageState();
}

class _MyProfileEditPageState extends State<_MyProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  String _nickname;
  File _avataFile;

  @override
  void initState() {
    _nickname = widget.user.nickname;
    _avataFile = null;
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return MyScaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SafeArea(
        child: Form(
          child: Column(
            children: <Widget>[
              _AvataField(
                user: widget.user,
                maxRadius: 48,
                initialValue: _avataFile,
                onSaved: (file) => _avataFile = file,
              ),
              TextFormField(
                validator: (value) {
                  final length = value.trim().length;
                  if (length == 0)
                    return "Please enter nickname";
                  else if (length < NICKNAME_MIN_LENGTH)
                    return "Nickname is too short";
                  else
                    return null;
                },
                onSaved: (newValue) => _nickname = newValue,
                decoration: const InputDecoration(hintText: "Nickname"),
                initialValue: _nickname,
                maxLength: NICKNAME_MAX_LENGTH,
              ),
              SizedBox(height: 20),
              FlatButton.icon(
                onPressed: _onSave,
                icon: const Icon(Icons.save),
                label: const Text("Save"),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          key: _formKey,
          autovalidate: true,
        ),
      ),
    );
  }

  void _onSave() {
    final state = _formKey.currentState;
    if (state.validate()) {
      state.save();
      BlocProvider.of<AuthBloc>(context).add(AuthEventRequestUpdateProfile(
        uid: widget.user.uid,
        nickname: _nickname,
        photo: _avataFile,
      ));
      Navigator.pop(context);
    }
  }
}

class _AvataField extends FormField<File> {
  _AvataField({
    @required final User user,
    final FormFieldSetter<File> onSaved,
    final FormFieldValidator<File> validator,
    final File initialValue,
    final bool autovalidate = false,
    final double minRadius,
    final double maxRadius,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidate: autovalidate,
          builder: (final state) => PopupMenuButton(
            child: state.value == null
                ? MyAvata(user, minRadius: minRadius, maxRadius: maxRadius)
                : CircleAvatar(
                    backgroundImage: FileImage(state.value),
                    minRadius: minRadius,
                    maxRadius: maxRadius,
                  ),
            itemBuilder: (context) => <PopupMenuEntry<_ImageSource>>[
              const PopupMenuItem<_ImageSource>(
                value: _ImageSource.camera,
                child: const ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("From Camera"),
                ),
              ),
              const PopupMenuItem<_ImageSource>(
                value: _ImageSource.gallery,
                child: const ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("From Gallery"),
                ),
              ),
              const PopupMenuItem<_ImageSource>(
                value: _ImageSource.cancel,
                child: const ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text("Cancel Change"),
                ),
              ),
            ],
            onSelected: (final _ImageSource source) async {
              if (source == _ImageSource.cancel)
                state.didChange(null);
              else {
                final file = await ImagePicker.pickImage(
                  source: source.source,
                  imageQuality: 50,
                  maxWidth: 256,
                  maxHeight: 256,
                  preferredCameraDevice: CameraDevice.front,
                );
                if (null != file) state.didChange(file);
              }
            },
          ),
        );
}

enum _ImageSource { camera, gallery, cancel }

extension _ImageSourceExtension on _ImageSource {
  ImageSource get source {
    return this == _ImageSource.gallery
        ? ImageSource.gallery
        : ImageSource.camera;
  }
}
