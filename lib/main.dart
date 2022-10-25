import 'package:flutter/material.dart';

import 'src/nl_choice/nl_choice.dart';
import 'src/full_exam/full_exam.dart';

import 'src/components/voice_input.dart';

void main() {
  runApp(ProjectSOE());
}

class ProjectSOE extends StatelessWidget {
  ProjectSOE({super.key});
  List<String> words1 = ['a', 'b', 'c'];
  List<String> words2 = [
    'ab',
    'aab',
    'aaaab',
    'aaaaaab',
    'aaaaaaaaab',
  ];
  List<String> words3 = [
    'aaaaaaaaaaaaaaaaaaaaaa',
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaa1'
  ];
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project SoE Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FullExamination(
        singleWords: words1,
        doubleWords: words2,
        sentances: words3,
      ),
    );
  }
}
