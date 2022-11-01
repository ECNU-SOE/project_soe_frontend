import 'package:flutter/material.dart';

import 'src/nl_choice/nl_choice.dart';
import 'src/full_exam/full_exam.dart';

import 'src/components/voice_input.dart';

void main() {
  runApp(ProjectSOE());
}

class ProjectSOE extends StatelessWidget {
  ProjectSOE({super.key});
  // FIXME 22.11.1 实现它
  Future<bool> _queryFirstTimeUse() async {
    return true;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project SoE Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // FIXME 22.11.1
      // initialRoute : _queryFirstTimeUse()? NativeLanguageChoice.routeName : ApplicationHome.routeName;
      initialRoute: NativeLanguageChoice.routeName,
    );
  }
}
