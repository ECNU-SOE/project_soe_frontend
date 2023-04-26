import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

// const TextStyle gTextStyleTitle = TextStyle(
//   fontFamily:
// )

// 思源黑体24号 颜色 45, 55, 71
const TextStyle gTitleStyle = TextStyle(
  color: Color.fromARGB(255, 45, 55, 71),
  fontFamily: 'SourceSans',
  fontSize: 24.0,
);

// 思源黑体16号 颜色 97, 97, 97
const TextStyle gSubtitleStyle0 = TextStyle(
  color: Color.fromARGB(255, 97, 97, 97),
  fontFamily: 'SourceSans',
  fontSize: 16.0,
);

// 思源宋体18号 颜色 1, 41, 50,
const TextStyle gSubtitleStyle = TextStyle(
  color: Color.fromARGB(255, 1, 41, 50),
  fontFamily: 'SourceSerif',
  fontSize: 18.0,
);

// 思源黑体14号 颜色 1, 41, 50,
const TextStyle gInfoTextStyle = TextStyle(
  color: Color.fromARGB(255, 1, 41, 50),
  fontFamily: 'SourceSans',
  fontSize: 14.0,
);

// 思源宋体14号 颜色 97, 97, 97
const TextStyle gInfoTextStyle0 = TextStyle(
  color: Color.fromARGB(255, 97, 97, 97),
  fontFamily: 'SourceSerif',
  fontSize: 14.0,
);

// 思源黑体12号 颜色 46, 71, 110
const TextStyle gInfoTextStyle1 = TextStyle(
  color: Color.fromARGB(255, 46, 71, 110),
  fontFamily: 'SourceSans',
  fontSize: 12.0,
);

// RGBA white 100
const Color gColorFFFFFFRGBA = Color.fromARGB(255, 255, 255, 255);
// RGBA 227 237 247 100
const Color gColorE3EDF7RGBA = Color.fromARGB(255, 227, 237, 247);
// RGBA 225 235 245 100
const Color gColorE1EBF5RGBA = Color.fromARGB(255, 225, 235, 245);
// RGBA 202 228 241 100
const Color gColorCAE4F1RGBA = Color.fromARGB(255, 202, 228, 241);
// RGBA 151 180 207 100
const Color gColor7199D9RGBA = Color.fromARGB(255, 151, 180, 207);
// RGBA 116 159 196 100
const Color gColor749FC4 = Color.fromARGB(255, 116, 159, 196);
// RGBA 123 203 230 48
const Color gColor7BCBE6RGBA48 = Color.fromARGB(120, 123, 203, 230);
// RGBA 110 129 160 100
const Color gColor6E81A0RGBA = Color.fromARGB(255, 110, 129, 160);

ButtonStyle gRoundHover749FC4 = ElevatedButton.styleFrom(
  shape: CircleBorder(),
  backgroundColor: gColor749FC4,
  shadowColor: gColor7BCBE6RGBA48,
);

ButtonStyle gRoundHoverE3EDF7 = ElevatedButton.styleFrom(
  shape: CircleBorder(),
  // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  // maximumSize: Size(120.0, 120.0),
  // fixedSize: Size.fromRadius(40),
  // minimumSize: Size(12.0, 12.0),
  backgroundColor: gColorE3EDF7RGBA,
  shadowColor: gColor7BCBE6RGBA48,
);

ButtonStyle gRectHoverE3EDF7 = ButtonStyle();

ButtonStyle gViewAppHomeEntranceButtonStyle = ButtonStyle(padding:
    MaterialStateProperty.resolveWith<EdgeInsets?>((Set<MaterialState> states) {
  if (states.contains(MaterialState.hovered)) return EdgeInsets.all(1.0);
  if (states.contains(MaterialState.focused)) return EdgeInsets.all(1.0);
  return EdgeInsets.all(2.0);
}), backgroundColor:
    MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
  return Colors.white70;
}), overlayColor:
    MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
  if (states.contains(MaterialState.hovered)) return Colors.grey[400];
  return null; // Defer to the widget's default.
}));

ButtonStyle gViewExamNavButtonStyle = ButtonStyle(padding:
    MaterialStateProperty.resolveWith<EdgeInsets?>((Set<MaterialState> states) {
  if (states.contains(MaterialState.hovered)) return EdgeInsets.all(1.0);
  if (states.contains(MaterialState.focused)) return EdgeInsets.all(1.0);
  return EdgeInsets.all(2.0);
}), backgroundColor:
    MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
  return Colors.white70;
}), overlayColor:
    MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
  if (states.contains(MaterialState.hovered)) return Colors.grey[400];
  return null; // Defer to the widget's default.
}));

ButtonStyle gViewExamSubButtonStyle = ButtonStyle(padding:
    MaterialStateProperty.resolveWith<EdgeInsets?>((Set<MaterialState> states) {
  if (states.contains(MaterialState.hovered)) return EdgeInsets.all(1.0);
  if (states.contains(MaterialState.focused)) return EdgeInsets.all(1.0);
  return EdgeInsets.all(2.0);
}), backgroundColor:
    MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
  return Colors.white70;
}), overlayColor:
    MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
  if (states.contains(MaterialState.hovered)) return Colors.grey[400];
  return null; // Defer to the widget's default.
}));

ButtonStyle gPersonalPageLoginButtonStyle = ButtonStyle(padding:
    MaterialStateProperty.resolveWith<EdgeInsets?>((Set<MaterialState> states) {
  if (states.contains(MaterialState.hovered)) return EdgeInsets.all(1.0);
  if (states.contains(MaterialState.focused)) return EdgeInsets.all(1.0);
  return EdgeInsets.all(2.0);
}), backgroundColor:
    MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
  return Colors.white70;
}), overlayColor:
    MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
  if (states.contains(MaterialState.hovered)) return Colors.grey[400];
  return null; // Defer to the widget's default.
}));

ButtonStyle gPracticePageArticleButtonStyle = ButtonStyle(padding:
    MaterialStateProperty.resolveWith<EdgeInsets?>((Set<MaterialState> states) {
  if (states.contains(MaterialState.hovered)) return EdgeInsets.all(1.0);
  if (states.contains(MaterialState.focused)) return EdgeInsets.all(1.0);
  return EdgeInsets.all(2.0);
}), overlayColor:
    MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
  // if (states.contains(MaterialState.focused)) return Colors.red;
  if (states.contains(MaterialState.hovered)) return Colors.grey[400];
  // if (states.contains(MaterialState.pressed)) return Colors.blue;
  return null; // Defer to the widget's default.
}));

ButtonStyle gPracticePageSpeakingButtonStyle = ButtonStyle(padding:
    MaterialStateProperty.resolveWith<EdgeInsets?>((Set<MaterialState> states) {
  if (states.contains(MaterialState.hovered)) return EdgeInsets.all(1.0);
  if (states.contains(MaterialState.focused)) return EdgeInsets.all(1.0);
  return EdgeInsets.all(2.0);
}), overlayColor:
    MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
  // if (states.contains(MaterialState.focused)) return Colors.red;
  if (states.contains(MaterialState.hovered)) return Colors.grey[400];
  // if (states.contains(MaterialState.pressed)) return Colors.blue;
  return null; // Defer to the widget's default.
}));
