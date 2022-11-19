// TODO 11.2 实现此类.
import 'package:flutter/material.dart';
import 'package:project_soe/src/login/login_screen.dart';
import 'package:project_soe/src/login/authorition.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});
  static const String routeName = 'personal';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      onPressed: () {
        if (gAuthorithionToken == '') {
          Navigator.pushNamed(context, LoginScreen.routeName);
        }
      },
      child: Text('点击登录'),
    );
  }
}
