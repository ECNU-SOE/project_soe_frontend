import 'package:flutter/material.dart';
import 'package:project_soe/src/CComponents/ComponentEditBox.dart';
import 'package:project_soe/src/VAuthorition/ViewLogin.dart';
import 'package:project_soe/src/VAuthorition/ViewSignupSuccess.dart';

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
      initialRoute: ViewLogin.routeName,
      theme: ThemeData(fontFamily: 'SourceSans'),
      routes: sNavigationRoutes,
    );
  }
}
