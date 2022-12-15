import 'package:flutter/material.dart';
import 'package:project_soe/src/data/styles.dart';

class Subtitle extends StatelessWidget {
  final String label;
  const Subtitle({super.key, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(18.0),
          child: Text(
            label,
            style: gSubtitleStyle,
          ),
        ),
      ],
    );
  }
}
