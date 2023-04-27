import 'package:flutter/material.dart';
import 'package:project_soe/src/CComponents/ComponentRoundButton.dart';

import 'package:project_soe/src/GGlobalParams/Styles.dart';

import 'package:project_soe/src/VPersonalPage/ViewPersonal.dart';
import 'package:project_soe/src/VPracticePage/ViewPractice.dart';
import 'package:project_soe/src/VClassPage/ViewClass.dart';
import 'package:project_soe/src/s_o_e_icons_icons.dart';

import 'PageAppHome.dart';

class ViewAppHome extends StatelessWidget {
  static const String routeName = 'apphome';
  ViewAppHome({super.key});
  @override
  Widget build(BuildContext context) => _ViewAppHomeImpl();
}

class _ViewAppHomeImpl extends StatefulWidget {
  const _ViewAppHomeImpl({super.key});
  @override
  State<_ViewAppHomeImpl> createState() => _ViewAppHomeImplState();
}

class _ViewAppHomeImplState extends State<_ViewAppHomeImpl> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    PracticePage(),
    ClassPage(),
    PersonalPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildSelectedIcon(IconData iconData, int index) {
    return ComponentRoundButton(
      func: () => _onItemTapped(index),
      color: gColorE3EDF7RGBA,
      child: Icon(
        iconData,
        color:
            (index == _selectedIndex) ? Color(0x749FC4ff) : Color(0x749FC4ff),
      ),
      shadowIn: (index == _selectedIndex),
      height: 36,
      width: 64,
      radius: 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomSheet: Container(
        color: gColorE3EDF7RGBA,
        child: Padding(
          padding: EdgeInsets.only(top: 7, bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSelectedIcon(SOEIcons.home, 0),
              _buildSelectedIcon(SOEIcons.edit, 1),
              _buildSelectedIcon(SOEIcons.add_group, 2),
              _buildSelectedIcon(SOEIcons.person, 3),
            ],
          ),
        ),
      ),
      backgroundColor: gColorE3EDF7RGBA,
    );
  }
}
