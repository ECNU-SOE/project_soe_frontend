import 'package:flutter/material.dart';
import 'package:project_soe/src/VAppHome/ViewAppHome.dart';

import 'src/LNavigation/LogicNavigation.dart';

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
