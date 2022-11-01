import 'dart:developer';
import 'package:flutter/material.dart';
import '../full_exam/full_exam.dart';

class NativeLanguageChoice extends StatelessWidget {
  NativeLanguageChoice({super.key});
  static const String routeName = 'nlchoice';
  // styles
  final _languageStyle = const TextStyle(fontSize: 18);
  final _titleStyle = const TextStyle(
    fontSize: 32,
    // backgroundColor: Colors.yellow,
    color: Colors.teal,
  );
  final _infoStyle = const TextStyle(
    fontSize: 24,
    // backgroundColor: Colors.red,
    color: Colors.blue,
  );
  // data
  final _languageList = [
    'English',
    'Franch',
    'Spanish',
  ];
  final String _title = 'Title';
  final String _info =
      'Choose your native language.\nPlaceholderPlaceholderPlaceholderPlaceholderPlaceholderPlaceholderPlaceholderPlaceholderPlaceholderPlaceholderPlaceholderPlaceholder';
  // view
  ListView _nlChoiceListViewBuilder() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _languageList.length * 2 + 3,
      itemBuilder: (context, ib) {
        if (ib == 0) {
          return ListTile(
            title: Text(
              _title,
              textAlign: TextAlign.center,
              style: _titleStyle,
            ),
          );
        }
        if (ib == 1) {
          return ListTile(
            title: Text(
              _info,
              textAlign: TextAlign.center,
              style: _infoStyle,
            ),
          );
        }
        final i = ib - 2;
        if (!i.isOdd) return const Divider();
        final index = i ~/ 2;
        return ListTile(
            title: Text(
              _languageList[index],
              style: _languageStyle,
              textAlign: TextAlign.center,
            ),
            trailing: const Icon(
              Icons.flag,
              color: Colors.red,
            ),
            onTap: () {
              log('Lanuage chose ${_languageList[index]}');
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _nlChoiceListViewBuilder(),
    );
  }
}
