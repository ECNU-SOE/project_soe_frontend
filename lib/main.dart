import 'package:flutter/material.dart';
import 'package:project_soe/src/CComponents/ComponentEditBox.dart';
import 'package:project_soe/src/VAppHome/ViewAppHome.dart';
import 'package:project_soe/src/VAuthorition/DataAuthorition.dart';
import 'package:project_soe/src/VAuthorition/MsgAuthorition.dart';
import 'package:project_soe/src/VAuthorition/ViewLogin.dart';
import 'package:project_soe/src/VAuthorition/ViewSignupSuccess.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'src/LNavigation/LogicNavigation.dart';
import 'src/GGlobalParams/Keywords.dart';

void main() {
  runApp(ProjectSOE());
}

class ProjectSOE extends StatelessWidget {
  ProjectSOE({super.key});
  // This widget is the root of your application.

  Future<bool> _storageCredentials() async {
    final storage = new FlutterSecureStorage();
    final String? savedUserName = await storage.read(key: s_passwordKey);
    final String? savedPassword = await storage.read(key: s_userNameKey);
    if (null == savedPassword || null == savedUserName) {
      return false;
    }
    String? msg = await MsgAuthorition()
        .postUserAuthorition(DataCredentials(savedUserName, savedPassword));
    if (null != msg) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _storageCredentials(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            title: 'Project SoE Demo',
            initialRoute:
                snapshot.data! ? ViewAppHome.routeName : ViewLogin.routeName,
            theme: ThemeData(fontFamily: 'SourceSans'),
            routes: sNavigationRoutes,
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
