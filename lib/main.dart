import 'package:flutter/material.dart';
import 'package:project_soe/src/VAppHome/app_home.dart';
import 'package:project_soe/src/VFullExam/full_exam_results.dart';
import 'package:project_soe/src/LAuthorition/login_screen.dart';

import 'src/VNlChoice/nl_choice.dart';
import 'src/VFullExam/full_exam.dart';

import 'src/CComponents/voice_input.dart';
import 'src/LNavigation/navigation_routes.dart';

void main() {
  runApp(ProjectSOE());
}

class ProjectSOE extends StatelessWidget {
  ProjectSOE({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project SoE Demo',
      initialRoute: ApplicationHome.routeName,
      // initialRoute: FullExaminationResult.routeName,
      routes: sNavigationRoutes,
    );
  }
}
