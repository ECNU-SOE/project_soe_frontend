import 'package:flutter/material.dart';
import 'package:project_soe/src/VAppHome/app_home.dart';
import 'package:project_soe/src/VFullExam/full_exam.dart';
import 'package:project_soe/src/VFullExam/full_exam_results.dart';
import 'package:project_soe/src/LAuthorition/login_screen.dart';
import 'package:project_soe/src/VNlChoice/nl_choice.dart';

Map<String, WidgetBuilder> sNavigationRoutes = {
  NativeLanguageChoice.routeName: (context) => NativeLanguageChoice(),
  FullExamination.routeName: (context) => FullExamination(),
  ApplicationHome.routeName: (context) => ApplicationHome(),
  FullExaminationResult.routeName: (context) => FullExaminationResult(),
  LoginScreen.routeName: (context) => LoginScreen(),
};
