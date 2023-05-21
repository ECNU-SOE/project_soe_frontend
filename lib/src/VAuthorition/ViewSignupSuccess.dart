import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_soe/src/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/src/GGlobalParams/Styles.dart';
import 'package:project_soe/src/VAuthorition/ViewLogin.dart';

class ViewSignupSuccess extends StatelessWidget {
  static String routeName = 'SignupSuccess';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE4F0FA),
      body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image(
          image: AssetImage('assets/signup_success.bmp'),
        ),
      ]),
      // ),
      bottomSheet: Container(
        color: Color(0xffE4F0FA),
        height: 120.0,
        child: Center(
          child: ComponentRoundButton(
            func: () {
              Navigator.of(context).pushReplacementNamed(ViewLogin.routeName);
            },
            color: Color(0xff7BCBE6),
            child: Text(
              '进入',
              style: gSubtitleStyle1,
            ),
            height: 45,
            width: 289,
            radius: 14,
          ),
        ),
      ),
    );
  }
}
