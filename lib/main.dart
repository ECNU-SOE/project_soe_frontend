import 'package:flutter/material.dart';
import 'package:project_soe/src/app_home/app_home.dart';
import 'package:project_soe/src/login/login_screen.dart';

import 'src/nl_choice/nl_choice.dart';
import 'src/full_exam/full_exam.dart';

import 'src/components/voice_input.dart';
import 'src/navigation/navigation_routes.dart';

void main() {
  runApp(ProjectSOE());
}

class ProjectSOE extends StatelessWidget {
  ProjectSOE({super.key});
  // FIXME 22.11.1 实现它
  Future<bool> _queryFirstTimeUse() async {
    return true;
  }

  final wordList = [
    'a',
    'b',
    'c',
    'd',
    'e',
  ];
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project SoE Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.orange,
        // cursorColor: Colors.orange,
        textTheme: TextTheme(
          headline3: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45.0,
            color: Colors.orange,
          ),
          button: TextStyle(
            fontFamily: 'OpenSans',
          ),
          subtitle1: TextStyle(fontFamily: 'NotoSans'),
          bodyText2: TextStyle(fontFamily: 'NotoSans'),
        ),
      ),
      // FIXME 22.11.1
      // initialRoute : _queryFirstTimeUse()? NativeLanguageChoice.routeName : ApplicationHome.routeName;
      // initialRoute: NativeLanguageChoice.routeName,
      initialRoute: LoginScreen.routeName,

      routes: sNavigationRoutes,
    );
  }
}
