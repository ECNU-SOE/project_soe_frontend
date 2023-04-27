import 'package:flutter/material.dart';
import 'package:project_soe/src/GGlobalParams/Styles.dart';

class ComponentTitle extends StatelessWidget {
  final String label;
  final TextStyle style;
  const ComponentTitle({super.key, required this.label, required this.style});
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
