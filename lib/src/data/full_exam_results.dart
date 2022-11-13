import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_soe/src/data/exam_data.dart';
import 'package:project_soe/src/components/voice_input.dart';

class FullExaminationResult extends StatelessWidget {
  final List<VoiceInputPage> voiceInputs;
  static const String routeName = 'fullExamResult';
  const FullExaminationResult({super.key, required this.voiceInputs});
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
