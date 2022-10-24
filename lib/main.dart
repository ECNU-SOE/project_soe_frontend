import 'package:flutter/material.dart';

import 'src/nlchoice/nlchoice.dart';
import 'src/fullExam/fullExam.dart';
import 'src/recorderExample.dart';

void main() {
  runApp(const ProjectSOE());
}

class ProjectSOE extends StatelessWidget {
  const ProjectSOE({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyApp();

    // return MaterialApp(
    //   title: 'Project SoE Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: NativeLanguageChoice(),
    // );
  }
}
