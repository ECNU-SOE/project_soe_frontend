import 'package:flutter/material.dart';
import 'package:project_soe/src/GGlobalParams/Styles.dart';

class ComponentCircleButton extends StatelessWidget {
  void Function() func;
  Color color;
  Widget child;
  double size;
  ComponentCircleButton({
    required this.func,
    required this.color,
    required this.child,
    required this.size,
  });
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        child: ElevatedButton(
          onPressed: func,
          style: ElevatedButton.styleFrom(
            elevation: 3,
            shape: CircleBorder(),
            backgroundColor: color,
            shadowColor: gColor7BCBE6RGBA48,
          ),
          child: child,
        ),
      );
}

class ComponentRoundButton extends StatelessWidget {
  void Function() func;
  Color color;
  Widget child;
  double height;
  double width;
  double radius;
  ComponentRoundButton({
    required this.func,
    required this.color,
    required this.child,
    required this.height,
    required this.width,
    required this.radius,
  });
  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: func,
          style: ElevatedButton.styleFrom(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius))),
            backgroundColor: color,
            shadowColor: gColor7BCBE6RGBA48,
          ),
          child: child,
        ),
      );
}
