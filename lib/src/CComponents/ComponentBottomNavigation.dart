import 'package:flutter/material.dart';
import 'package:project_soe/src/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/src/GGlobalParams/Styles.dart';
import 'package:project_soe/src/LNavigation/LogicNavigation.dart';
import 'package:project_soe/src/VAppHome/ViewAppHome.dart';
import 'package:project_soe/src/VAppHome/ViewGuide.dart';
import 'package:project_soe/src/VClassPage/ViewClass.dart';
import 'package:project_soe/src/VClassPage/ViewClassDetail.dart';
import 'package:project_soe/src/VPersonalPage/ViewEditPersonal.dart';
import 'package:project_soe/src/VPracticePage/ViewPractice.dart';
import 'package:project_soe/src/VPersonalPage/ViewPersonal.dart';
import 'package:project_soe/src/VUnImplemented/ViewUnimplemented.dart';
import 'package:project_soe/src/s_o_e_icons_icons.dart';

class ComponentBottomNavigator extends StatefulWidget {
  String curRouteName;
  ComponentBottomNavigator({super.key, required this.curRouteName});
  @override
  State<StatefulWidget> createState() => _ComponentBottomNavigatorState();
}

class _ComponentBottomNavigatorState extends State<ComponentBottomNavigator> {
  String? _findKey(String routeName) {
    for (String key in sRouteMap.keys) {
      final list = sRouteMap[key];
      if (list!.contains(routeName)) {
        return key;
      }
    }
    return null;
  }

  void _onItemTapped(BuildContext context, String dest) {
    final curRouteKey = _findKey(widget.curRouteName);
    setState(() {
      widget.curRouteName = dest;
    });
    bool destIsKey = sRouteMap.containsKey(dest);
    if (null == curRouteKey) {
      Navigator.of(context).pushReplacementNamed(dest);
      return;
    }
    // TODO 23.5.24 可能需要更细致的route规则
    if (destIsKey && curRouteKey != dest) {
    } else {
      Navigator.of(context).pushReplacementNamed(dest);
      return;
    }
    Navigator.of(context).pushNamed(dest);
  }

  Widget _buildSelectedIcon(
      BuildContext context, IconData iconData, String destRoute) {
    String? curKey = _findKey(widget.curRouteName);
    bool isSelected =
        (null == curKey) ? false : (_findKey(widget.curRouteName) == destRoute);
    return ComponentRoundButton(
      func: () => _onItemTapped(context, destRoute),
      color: gColorE3EDF7RGBA,
      child: Icon(
        iconData,
        color: isSelected ? Color(0x749FC4ff) : Color(0x749FC4ff),
      ),
      shadowIn: isSelected,
      height: 36,
      width: 64,
      radius: 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'bottom_navigator',
      child: Container(
        color: gColorE3EDF7RGBA,
        child: Padding(
          padding: EdgeInsets.only(top: 7, bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSelectedIcon(context, SOEIcons.home, ViewAppHome.routeName),
              _buildSelectedIcon(
                  context, SOEIcons.edit, ViewPractice.routeName),
              _buildSelectedIcon(
                  context, SOEIcons.person, ViewPersonal.routeName),
            ],
          ),
        ),
      ),
    );
  }
}
