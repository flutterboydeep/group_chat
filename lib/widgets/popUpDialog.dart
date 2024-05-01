import 'package:flutter/material.dart';

import 'package:group_chat/widgets/button.dart';

class PopupDialog extends StatelessWidget {
  final Widget content;
  final String title;
  final String buttonName;
  final VoidCallback okkButton;
  final Color okkButtonColor;
  final Color canCelButtonColor;
  const PopupDialog(
      {super.key,
      this.content = const Text("Exit"),
      this.title = "Your Text",
      this.buttonName = "Okk",
      required this.okkButton,
      this.canCelButtonColor = const Color.fromARGB(255, 202, 197, 197),
      this.okkButtonColor = const Color.fromARGB(255, 185, 242, 187)});

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }

  popdialog(context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            backgroundColor: Color.fromARGB(255, 255, 254, 254),
            content: content,
            actions: [
              CustomButton(
                  text: "Cancel",
                  backgroundColor: canCelButtonColor,
                  buttonWidth: 100,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              CustomButton(
                text: buttonName,
                backgroundColor: okkButtonColor,
                buttonWidth: 100,
                onPressed: okkButton,
                // if (addGroupCtrl.text.trim().toString().isNotEmpty) {
                //   await DataBaseServices().createGroup(
                //     username,
                //     FirebaseAuth.instance.currentUser!.uid,
                //     addGroupCtrl.text.trim().toString(),
                //   );
                //   Navigator.of(context).pop();
                // }
              )
            ],
          );
        });
  }
}
