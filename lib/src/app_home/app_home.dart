import 'package:flutter/material.dart';
import '../personal_page/personal_page.dart';
import '../practice_page/practice_page.dart';
import 'home_page.dart';

class ApplicationHome extends StatelessWidget {
  static const String routeName = 'apphome';
  ApplicationHome({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.book)),
            Tab(icon: Icon(Icons.person)),
          ],
        ),
      ),
      body: const TabBarView(
        children: [
          HomePage(),
          PracticePage(),
          PersonalPage(),
        ],
      ),
    );
  }
}
