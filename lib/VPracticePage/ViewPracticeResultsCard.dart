import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentAppBar.dart';
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VAppHome/ViewAppHome.dart';
import 'package:project_soe/VAuthorition/ViewLogin.dart';
import 'package:project_soe/VExam/DataQuestion.dart';
import 'package:project_soe/VPracticePage/DataPractice.dart';
import 'package:project_soe/VExam/ViewExam.dart';
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/VExam/DataQuestion.dart';

import 'package:http/http.dart' as http;

class ViewPracticeResultsCard extends StatelessWidget {
  static const String routeName = 'practiceResultsCard';

  @override
  Widget build(BuildContext context) {
    return Text("data");
  }
}