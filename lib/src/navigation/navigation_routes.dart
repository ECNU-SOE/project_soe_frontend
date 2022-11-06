import 'package:flutter/material.dart';
import 'package:project_soe/src/app_home/app_home.dart';
import 'package:project_soe/src/full_exam/full_exam.dart';
import 'package:project_soe/src/nl_choice/nl_choice.dart';

Map<String, WidgetBuilder> sNavigationRoutes = {
  NativeLanguageChoice.routeName: (context) => NativeLanguageChoice(),
  FullExamination.routeName: (context) => FullExamination(),
  ApplicationHome.routeName: (context) => ApplicationHome(),
};
