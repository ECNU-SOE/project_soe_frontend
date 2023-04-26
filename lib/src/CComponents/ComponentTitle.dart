import 'package:flutter/material.dart';
import 'package:project_soe/src/GGlobalParams/Styles.dart';
import 'package:project_soe/src/GGlobalParams/styles.dart';

class Title extends StatelessWidget {
  final String label;
  final TextStyle style;
  const Title({super.key, required this.label, required this.style});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4.0, top: 4.0),
            child: Text(
              label,
              style: style,
            ),
          ),
        ),
      ],
    );
  }
}
