import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool ispass;
  final String label;
  final String hintText;
  final TextInputType textInputType;
  final bool filled;
  final int maxnum;
  final bool readOnly;
  final Widget suffixWidget;

  TextFieldWidget({
    super.key,
    required this.textEditingController,
    this.ispass = false,
    this.label = '🖊',
    this.hintText = '',
    required this.textInputType,
    this.filled = true,
    this.maxnum = 10,
    this.readOnly = false,
    this.suffixWidget = const SizedBox(
      width: 0,
    ),
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      readOnly: widget.readOnly,
      // style: TextStyle(),
      // textAlign: TextAlign.left,

      controller: widget.textEditingController,

      decoration: InputDecoration(
        hintText: widget.hintText,
        prefix: SizedBox(width: 10),
        suffixIcon: widget.suffixWidget,
        label: Text(widget.label),
        border: inputBorder,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.background, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        filled: widget.filled,
        contentPadding: const EdgeInsets.all(15),
      ),
      keyboardType: widget.textInputType,
      obscureText: widget.ispass,
    );
  }
}
