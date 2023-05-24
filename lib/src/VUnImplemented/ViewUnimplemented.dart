import 'package:flutter/material.dart';
import 'package:project_soe/src/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/src/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/src/GGlobalParams/Styles.dart';

class ViewUnimplemented extends StatelessWidget {
  static String routeName = 'Unimplemented';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true),
      body: Container(
        child: ComponentSubtitle(
          label: '内容尚在开发中, 尽请期待...',
          style: gTitleStyle,
        ),
      ),
      bottomNavigationBar:
          ComponentBottomNavigator(curRouteName: ViewUnimplemented.routeName),
    );
  }
}
