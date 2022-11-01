import 'dart:js';

import 'package:flutter/material.dart';
import 'package:project_soe/src/app_home/app_home.dart';
import 'package:project_soe/src/full_exam/full_exam.dart';
import 'package:project_soe/src/nl_choice/nl_choice.dart';

// FIXME 22.11.1 这些都是临时数据, 以后会用network的形式实现请求, 届时将此类的build参数改为单语言, 此类的build函数改为Future
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

Map<String, WidgetBuilder> sNavigationRoutes = {
  NativeLanguageChoice.routeName: (context) => NativeLanguageChoice(),
  FullExamination.routeName: (context) => FullExamination(
        singleWords: words1,
        doubleWords: words2,
        sentances: words3,
      ),
  ApplicationHome.routeName: (context) => ApplicationHome(),
};
