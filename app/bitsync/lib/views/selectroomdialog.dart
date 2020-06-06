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
  Widget build(final BuildContext context) {
    return AlertDialog(
      content: Form(
        key: formKey,
        child: Container(
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
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
                onSaved: (newValue) => setState(() => roomId = newValue.trim()),
                initialValue: roomId,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                maxLength: 12,
                decoration: InputDecoration(
                  hintText: "9~12 digitals",
                  labelText: "Room ID",
                ),
              ),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
          padding: const EdgeInsets.all(10),
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
      actions: [
        FlatButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: const Text("Enter"),
          onPressed: valid
              ? () {
                  formKey.currentState.save();
                  Navigator.pop(context, roomId);
                }
              : null,
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      // backgroundColor: Colors.transparent,
    );
  }
}
