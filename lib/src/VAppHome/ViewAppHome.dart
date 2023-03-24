import 'package:flutter/material.dart';
import 'package:project_soe/src/GGlobalParams/Styles.dart';

import '../VPersonalPage/ViewPersonal.dart';
import '../VPracticePage/ViewPractice.dart';
import '../VClassPage/ViewClass.dart';
import 'PageAppHome.dart';

class ApplicationHome extends StatelessWidget {
  static const String routeName = 'apphome';
  ApplicationHome({super.key});
  @override
  Widget build(BuildContext context) => ApplicationHomeBody();
}

class ApplicationHomeBody extends StatefulWidget {
  const ApplicationHomeBody({super.key});
  @override
  State<ApplicationHomeBody> createState() => _ApplicationHomeBodyState();
}

class _ApplicationHomeBodyState extends State<ApplicationHomeBody> {
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
