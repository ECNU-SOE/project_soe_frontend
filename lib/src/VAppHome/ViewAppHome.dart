import 'package:flutter/material.dart';

import 'package:project_soe/src/GGlobalParams/Styles.dart';

import 'package:project_soe/src/VPersonalPage/ViewPersonal.dart';
import 'package:project_soe/src/VPracticePage/ViewPractice.dart';
import 'package:project_soe/src/VClassPage/ViewClass.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '主页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: '练习',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '课堂',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '个人',
          ),
        ],
        selectedFontSize: 18.0,
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.yellow,
        selectedItemColor: Colors.brown,
        onTap: _onItemTapped,
      ),
    );
  }
}
