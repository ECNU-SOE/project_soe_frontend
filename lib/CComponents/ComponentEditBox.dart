import 'package:flutter/material.dart';
import 'package:project_soe/GGlobalParams/styles.dart';

class ComponentEditBox extends StatefulWidget {
  bool hideWord;
  // String wrongInfo;
  // String title;
  String hintInfo;
  String word;
  double height;
  double width;
  bool enable;

  String getValue() {
    return word;
  }

  ComponentEditBox({
    super.key,
    // required this.wrongInfo,
    // required this.title,
    required this.hintInfo,
    required this.height,
    required this.width,
    this.hideWord = true,
    this.enable = true,
    this.word = '',
  });
  @override
  State<ComponentEditBox> createState() => _ComponentEditBoxState();
}

class _ComponentEditBoxState extends State<ComponentEditBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: gColorE3EDF7RGBA,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        enabled: widget.enable,
        cursorColor: gColorE3EDF7RGBA,
        decoration: InputDecoration(
          fillColor: gColorE3EDF7RGBA,
          hintText: widget.hintInfo,
          hintStyle: gInfoTextStyle,
          floatingLabelStyle: gInfoTextStyle,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
        obscureText: widget.hideWord,
        onChanged: (value) {
          setState(() {
            widget.word = value;
          });
        },
      ),
    );
  }
}
