import 'package:flutter/material.dart';

import 'src/nl_choice/nl_choice.dart';
import 'src/full_exam/full_exam.dart';

import 'src/components/voice_input.dart';

void main() {
  runApp(const ProjectSOE());
}

class ProjectSOE extends StatelessWidget {
  const ProjectSOE({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project SoE Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VoiceInputComponent(label: 'TestLabel'),
    );
    // return MyApp();
    // return MaterialApp(
    //   title: 'Project SoE Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: NativeLanguageChoice(),
    // );
  }
}
