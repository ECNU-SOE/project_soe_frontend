import 'package:flutter/material.dart';

import 'package:project_soe/src/VAppHome/ViewAppHome.dart';
import 'package:project_soe/src/VAppHome/ViewGuide.dart';
import 'package:project_soe/src/VAuthorition/ViewSignup.dart';
import 'package:project_soe/src/VAuthorition/ViewSignupSuccess.dart';
import 'package:project_soe/src/VClassPage/ViewClass.dart';
import 'package:project_soe/src/VClassPage/ViewClassDetail.dart';
import 'package:project_soe/src/VExam/ViewExam.dart';
import 'package:project_soe/src/VExam/ViewExamResults.dart';
import 'package:project_soe/src/VAuthorition/ViewLogin.dart';
import 'package:project_soe/src/VNativeLanguageChoice/ViewNativeLanguageChoice.dart';
import 'package:project_soe/src/VPersonalPage/ViewEditPersonal.dart';
import 'package:project_soe/src/VPersonalPage/ViewPersonal.dart';
import 'package:project_soe/src/VPracticePage/ViewPractice.dart';
import 'package:project_soe/src/VPracticePage/ViewPracticeFollow.dart';
import 'package:project_soe/src/VUnImplemented/ViewUnimplemented.dart';

Map<String, WidgetBuilder> sNavigationRoutes = {
  ViewAppHome.routeName: (context) => ViewAppHome(),
  ViewClassDetail.routeName: (context) => ViewClassDetail(),
  ViewEditPersonal.routeName: (context) => ViewEditPersonal(),
  ViewExam.routeName: (context) => ViewExam(),
  ViewExamResult.routeName: (context) => ViewExamResult(),
  ViewGuide.routeName: (context) => ViewGuide(),
  ViewLogin.routeName: (context) => ViewLogin(),
  ViewNativeLanuageChoose.routeName: (context) => ViewNativeLanuageChoose(),
  ViewPractice.routeName: (context) => ViewPractice(),
  ViewPersonal.routeName: (context) => ViewPersonal(),
  ViewPracticeFollow.routeName: (context) => ViewPracticeFollow(),
  ViewSignup.routeName: (context) => ViewSignup(),
  ViewSignupSuccess.routeName: (context) => ViewSignupSuccess(),
  ViewUnimplemented.routeName: (context) => ViewUnimplemented(),
};

Map<String, List<String>> sRouteMap = {
  ViewAppHome.routeName: [
    ViewAppHome.routeName,
    ViewGuide.routeName,
    ViewUnimplemented.routeName
  ],
  ViewPractice.routeName: [
    ViewPractice.routeName,
    ViewClass.routeName,
    ViewClassDetail.routeName
  ],
  ViewPersonal.routeName: [ViewPersonal.routeName, ViewEditPersonal.routeName],
};
