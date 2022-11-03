// TODO 11.2 实现此类.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String routeName = 'home';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Icon(
      Icons.dangerous,
      color: Colors.red,
    );
  }
}
