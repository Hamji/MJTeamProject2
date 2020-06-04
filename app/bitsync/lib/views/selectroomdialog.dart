import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectRoomDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SelectRoomDialogState();
}

class _SelectRoomDialogState extends State<SelectRoomDialog> {
  final formKey = GlobalKey<FormState>();

  String roomId;
  bool valid;

  @override
  void initState() {
    roomId = "";
    valid = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: const Text("Enter Room ID"),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              validator: (value) {
                value = value.trim();
                if (value.isEmpty)
                  return "Please enter id";
                else if (null == int.tryParse(value))
                  return "Plase enter valid id";
                else if (value.length < 9)
                  return "Too short";
                else
                  return null;
              },
              initialValue: roomId,
              onChanged: (value) => setState(() => roomId = value.trim()),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
            ),
            FlatButton(
              child: const Text("Enter"),
              onPressed: valid
                  ? () {
                      Navigator.pop(context, roomId);
                    }
                  : null,
            )
          ],
        ),
        // autovalidate: true,
        onChanged: () {
          if (formKey.currentState?.validate() ?? false)
            setState(() {
              valid = true;
            });
          else
            setState(() {
              valid = false;
            });
        },
      ),
    );
  }
}
