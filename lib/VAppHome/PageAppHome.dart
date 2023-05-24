// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:project_soe/src/CComponents/ComponentRoundButton.dart';

// import 'package:project_soe/src/GGlobalParams/Styles.dart';
// import 'package:project_soe/src/VAppHome/ViewGuide.dart';
// import 'package:project_soe/src/s_o_e_icons_icons.dart';
// import 'package:project_soe/src/CComponents/ComponentShadowedContainer.dart';
// import 'package:project_soe/src/CComponents/ComponentTitle.dart';
// import 'package:project_soe/src/CComponents/ComponentSubtitle.dart';
// import 'package:project_soe/src/LNavigation/LogicNavigation.dart';
// import 'package:project_soe/src/VNativeLanguageChoice/ViewNativeLanguageChoice.dart';
// import 'package:project_soe/src/VPracticePage/ViewPracticeFollow.dart';
// import 'package:project_soe/src/VUnImplemented/ViewUnimplemented.dart';
// import 'package:project_soe/src/VAppHome/ViewGuide.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//   static const String routeName = 'home';

//   Widget _buildRectWidget(int retId, BuildContext context, Function() func) {
//     return ComponentRoundButton(
//         func: func,
//         color: gColorE3EDF7RGBA,
//         child: Center(
//           child: Padding(
//             padding: EdgeInsets.all(32.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   ListHomeRecData[retId].icon,
//                   color: Color.fromARGB(255, 155, 185, 211),
//                 ),
//                 ComponentTitle(
//                     label: ListHomeRecData[retId].label, style: gInfoTextStyle)
//               ],
//             ),
//           ),
//         ),
//         height: 137,
//         width: 137,
//         radius: 32);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: gColorE3EDF7RGBA,
//       body: 
//     );
//   }
// }
