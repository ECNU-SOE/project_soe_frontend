import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentAppBar.dart';
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VMistakeBook/DataMistakeBook.dart';
import 'package:project_soe/VExam/ViewExamResults.dart';
import 'package:project_soe/VExam/DataQuestion.dart';
import 'package:project_soe/CComponents/ComponentVoiceInput.dart';
import 'package:project_soe/s_o_e_icons_icons.dart';

import 'package:element_ui/animations.dart';
import 'package:element_ui/widgets.dart';

class ViewMistakeCard extends StatefulWidget {
  static String routeName = 'mistakeCard';
  DataQuestionPageMain dataQuestionPageMain;
  ViewMistakeCard({super.key, required this.dataQuestionPageMain,});

  @override
  State<ViewMistakeCard> createState() => _ViewMistakeCardState();
}

class _ViewMistakeCardState extends State<ViewMistakeCard> {
  ComponentVoiceInput? _inputPage;
  
  @override
  Widget build(BuildContext context) {
    _inputPage = ComponentVoiceInput(dataPage: widget.dataQuestionPageMain, titleShow: false);
    
    return Container(child: _inputPage);
  }
}