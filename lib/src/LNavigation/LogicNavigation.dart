import 'package:flutter/material.dart';

import 'package:project_soe/src/VAppHome/ViewAppHome.dart';
import 'package:project_soe/src/VClassPage/ViewClassDetail.dart';
import 'package:project_soe/src/VExam/ViewExam.dart';
import 'package:project_soe/src/VExam/ViewExamResults.dart';
import 'package:project_soe/src/VAuthorition/ViewLogin.dart';
import 'package:project_soe/src/VNativeLanguageChoice/ViewNativeLanguageChoice.dart';
import 'package:project_soe/src/VPracticePage/ViewPracticeFollow.dart';

Map<String, WidgetBuilder> sNavigationRoutes = {
  ViewNativeLanuageChoose.routeName: (context) => ViewNativeLanuageChoose(),
  ViewExam.routeName: (context) => ViewExam(),
  ViewAppHome.routeName: (context) => ViewAppHome(),
  ViewExamResult.routeName: (context) => ViewExamResult(),
  ViewClassDetail.routeName: (context) => ViewClassDetail(),
  ViewLogin.routeName: (context) => ViewLogin(),
  ViewPracticeFollow.routeName: (context) => ViewPracticeFollow(),
};
