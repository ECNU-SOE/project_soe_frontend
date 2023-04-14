import 'package:flutter/material.dart';

const TextStyle gSubtitleStyle = TextStyle(
  color: Colors.black87,
  fontSize: 20.0,
);

const TextStyle gViewAppHomeListitemStyle = TextStyle(
  color: Colors.black54,
  fontSize: 18.0,
);

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

const TextStyle gViewExamSubTitleStyle = TextStyle(
  color: Colors.amber,
  fontSize: 20.0,
);

const TextStyle gViewExamTitleStyle = TextStyle(
  color: Colors.amber,
  fontSize: 22.0,
);

const TextStyle gViewExamTextStyle = TextStyle(
  color: Colors.black87,
  fontSize: 18.0,
);

const TextStyle gViewExamResultTextStyle = TextStyle(
  color: Colors.black87,
  fontSize: 12.0,
);

const TextStyle gViewExamResultSubtitleStyle = TextStyle(
  color: Colors.black87,
  fontSize: 18.0,
);

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

const TextStyle gViewChooseNativeLanuageTitleStyle = TextStyle(
  color: Colors.amber,
  fontSize: 30.0,
);
const TextStyle gViewChooseNativeLanuageListStyle = TextStyle(
  color: Colors.amber,
  fontSize: 20.0,
);
const TextStyle gViewChooseNativeLanuageInfoStyle = TextStyle(
  color: Colors.amber,
  fontSize: 30.0,
);

const TextStyle gVoiceInputSentanceStyle = TextStyle(
  color: Colors.blue,
  fontSize: 24.0,
);

const TextStyle gVoiceInputWordStyle = TextStyle(
  color: Colors.blue,
  fontSize: 30.0,
);

const TextStyle gClassPageAdsStyle = TextStyle(
  color: Colors.black87,
  fontSize: 20.0,
);

const TextStyle gClassPageListitemStyle = TextStyle(
  color: Colors.black54,
  fontSize: 18.0,
);

const TextStyle gClassPageTextStyle = TextStyle(
  color: Colors.black54,
  fontSize: 18.0,
);

const TextStyle gPracticePageTabStyle = TextStyle(
  color: Colors.black87,
  fontSize: 20.0,
);

const TextStyle gPracticePageSubtitleStyle = TextStyle(
  color: Colors.black87,
  fontSize: 24.0,
);

const TextStyle gPracticePageTextStyle = TextStyle(
  color: Colors.black87,
  fontSize: 16.0,
);

const TextStyle gPracticePageListitemStyle = TextStyle(
  color: Colors.black54,
  fontSize: 18.0,
);

const TextStyle gPersonalPageNicknameStyle = TextStyle(
  color: Colors.black87,
  fontSize: 24.0,
);

const TextStyle gPersonalPageDetailStyle = TextStyle(
  color: Colors.blue,
  fontSize: 18.0,
);

const TextStyle gPersonalPageLabelStyle = TextStyle(
  color: Colors.black87,
  fontSize: 16.0,
);

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
