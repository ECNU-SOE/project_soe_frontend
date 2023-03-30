import 'package:flutter/material.dart';

import 'package:project_soe/src/VAppHome/ViewAppHome.dart';
import 'package:project_soe/src/VFullExam/ViewFullExam.dart';
import 'package:project_soe/src/VFullExam/ViewFullExamResults.dart';
import 'package:project_soe/src/VAuthorition/ViewLogin.dart';
import 'package:project_soe/src/VNativeLanguageChoice/ViewNativeLanguageChoice.dart';
import 'package:project_soe/src/VPracticePage/ViewPracticeFollow.dart';

Map<String, WidgetBuilder> sNavigationRoutes = {
  NativeLanguageChoice.routeName: (context) => NativeLanguageChoice(),
  FullExamination.routeName: (context) => FullExamination(),
  ApplicationHome.routeName: (context) => ApplicationHome(),
  FullExaminationResult.routeName: (context) => FullExaminationResult(),
  LoginScreen.routeName: (context) => LoginScreen(),
  ViewPracticeFollow.routeName: (context) => ViewPracticeFollow(),
};
