import 'package:flutter/material.dart';

import 'package:project_soe/src/GGlobalParams/Styles.dart';

class ComponentShadowedContainer extends StatelessWidget {
  Widget child;
  Color color;
  Color shadowColor;
  double edgesHorizon;
  double edgesVertical;
  ComponentShadowedContainer({
    required this.child,
    required this.color,
    required this.shadowColor,
    required this.edgesHorizon,
    required this.edgesVertical,
  });
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: edgesHorizon, vertical: edgesVertical),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27),
            color: color,
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(1, 2), // changes position of shadow
              ),
            ],
          ),
          child: child,
        ),
      );
}
