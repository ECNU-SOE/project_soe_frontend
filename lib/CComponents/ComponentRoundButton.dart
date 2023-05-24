import 'package:flutter/material.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';

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
        child: TextButton(
          onPressed: func,
          style: ElevatedButton.styleFrom(
            elevation: 3,
            shape: CircleBorder(),
            backgroundColor: color,
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
  bool shadowIn = false;
  ComponentRoundButton({
    required this.func,
    required this.color,
    required this.child,
    required this.height,
    required this.width,
    required this.radius,
    this.shadowIn = false,
  });
  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        child: TextButton(
          onPressed: func,
          // style: ElevatedButton.styleFrom(
          //   elevation: 3,
          // ),
          child: child,
        ),
        decoration: BoxDecoration(
          // backgroundBlendMode: BlendMode.,
          borderRadius: BorderRadius.circular(27),
          color: color,
          boxShadow: shadowIn
              ? [
                  BoxShadow(
                    color: Color(0x7f000000),
                    spreadRadius: -1,
                    blurRadius: 1,
                    offset: Offset(-1, -1),
                  ),
                  BoxShadow(
                    color: Color(0x6fAEAEC0),
                    spreadRadius: -1,
                    blurRadius: 1,
                    offset: Offset(-1, -1),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Color(0x7f000000),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(1, 1),
                  ),
                  BoxShadow(
                    color: Color(0x6fAEAEC0),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(-1, -1), // changes position of shadow
                  ),
                ],
        ),
      );
}
