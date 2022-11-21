import 'package:flutter/material.dart';
import 'package:project_soe/src/app_home/app_home.dart';
import 'package:project_soe/src/full_exam/full_exam_results.dart';
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
  bool _queryFirstTimeUse() {
    return true;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project SoE Demo',
      initialRoute: _queryFirstTimeUse()
          ? NativeLanguageChoice.routeName
          : ApplicationHome.routeName,
      routes: sNavigationRoutes,
    );
  }
}
