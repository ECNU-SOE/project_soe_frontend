import 'package:flutter/material.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';

class ComponentSubtitle extends StatelessWidget {
  final String label;
  final TextStyle style;
  const ComponentSubtitle(
      {super.key, required this.label, required this.style});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, bottom: 4.0, top: 4.0),
          child: Text(
            label,
            style: style,
          ),
        ),
      ],
    );
  }
}
