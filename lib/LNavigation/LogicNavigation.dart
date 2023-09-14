// import 'dart:js';

// import 'dart:js';

import 'package:flutter/material.dart';

import 'package:project_soe/VAppHome/ViewAppHome.dart';
import 'package:project_soe/VAppHome/ViewGuide.dart';
import 'package:project_soe/VAuthorition/ViewSignup.dart';
import 'package:project_soe/VAuthorition/ViewSignupSuccess.dart';
import 'package:project_soe/VClassPage/ViewClass.dart';
import 'package:project_soe/VClassPage/ViewClassDetail.dart';
import 'package:project_soe/VClassPage/ViewMyClass.dart';
import 'package:project_soe/VExam/ViewExam.dart';
import 'package:project_soe/VExam/ViewExamResults.dart';
import 'package:project_soe/VAuthorition/ViewLogin.dart';
import 'package:project_soe/VMistakeBook/ViewMistakeBook.dart';
// import 'package:project_soe/VMistakeBook/ViewMistakeCard.dart';
import 'package:project_soe/VMistakeBook/ViewMistakeDetail.dart';
import 'package:project_soe/VNativeLanguageChoice/ViewNativeLanguageChoice.dart';
import 'package:project_soe/VPersonalPage/ViewEditPersonal.dart';
import 'package:project_soe/VPersonalPage/ViewPersonal.dart';
import 'package:project_soe/VPracticePage/ViewPractice.dart';
import 'package:project_soe/VPracticePage/ViewPracticeFollow.dart';
import 'package:project_soe/VPracticePage/ViewPracticeRandom.dart';
import 'package:project_soe/VPracticePage/ViewPracticeResults.dart';
import 'package:project_soe/VPracticePage/ViewPracticeResultsCard.dart';
import 'package:project_soe/VUnImplemented/ViewUnimplemented.dart';


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
  ViewMyClass.routeName: (context) => ViewMyClass(),
  ViewClass.routeName: (context) => ViewClass(),
  ViewMistakeBook.routeName: (context) => ViewMistakeBook(),
  ViewMistakeDetail.routeName: (context) => ViewMistakeDetail(),
  ViewPracticeRandom.routeName: (context) => ViewPracticeRandom(),
  ViewPracticeResults.routeName: (context) => ViewPracticeResults(),
  // ViewPracticeResultsCard.routeName: (context) => ViewPracticeResultsCard()
};

Map<String, List<String>> sRouteMap = {
  ViewAppHome.routeName: [
    ViewAppHome.routeName,
    ViewGuide.routeName,
    ViewUnimplemented.routeName
  ],
  ViewClass.routeName: [
    ViewPractice.routeName,
    ViewClass.routeName,
    ViewClassDetail.routeName,
    ViewMyClass.routeName,
    ViewMistakeBook.routeName,
    ViewMistakeDetail.routeName,
  ],
  ViewPersonal.routeName: [ViewPersonal.routeName, ViewEditPersonal.routeName],
};
