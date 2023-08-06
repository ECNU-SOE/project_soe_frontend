import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentAppBar.dart';
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/CComponents/ComponentRoundButton.dart';
import 'package:project_soe/CComponents/ComponentSubtitle.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VMistakeBook/DataMistake.dart';
import 'package:project_soe/VMistakeBook/ViewMistakeDetail.dart';

class ViewMistakeBook extends StatelessWidget {
  static const String routeName = 'mistake';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _ViewMistakeBookBody(),
      bottomNavigationBar: ComponentBottomNavigator(
        curRouteName: routeName,
      ),
      appBar: ComponentAppBar(
        hasBackButton: true,
        title: ComponentTitle(
          label: '错题本',
          style: gTitleStyle,
        ),
      ),
    );
  }
}

class _ViewMistakeBookBody extends StatefulWidget {
  @override
  State<_ViewMistakeBookBody> createState() => _ViewMistakeBookBodyState();
}

class _ViewMistakeBookBodyState extends State<_ViewMistakeBookBody> {
  Widget _buildItem(DataMistakeItem mistakeItem) => ListTile(
        leading: ComponentTitle(
            label: mistakeItem.mistakeTypeName, style: gTitleStyle),
        title: ComponentCircleButton(
            func: () => Navigator.of(context).pushNamed(
                ViewMistakeDetail.routeName,
                arguments: [0, mistakeItem.mistakeTypeCode]),
            color: gColor6E81A0RGBA,
            child: ComponentSubtitle(label: '查询一周', style: gSubtitleStyle),
            size: 25),
        trailing: ComponentCircleButton(
            func: () => Navigator.of(context).pushNamed(
                ViewMistakeDetail.routeName,
                arguments: [1, mistakeItem.mistakeTypeCode]),
            color: gColor6E81A0RGBA,
            child: ComponentSubtitle(label: '查询全部', style: gSubtitleStyle),
            size: 25),
      );

  Widget _buildBodyImpl(BuildContext context, DataMistakeBook mistakeBook) {
    List<Widget> wrongList = List.empty(growable: true);
    for (DataMistakeItem mistakeItem in mistakeBook.mistakeItemList) {
      wrongList.add(_buildItem(mistakeItem));
    }
    final listView = ListView(
      children: wrongList,
    );
    return listView;
  }

  @override
  Widget build(BuildContext buildContext) => FutureBuilder<DataMistakeBook>(
        future: getGetDataMistakeBook(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildBodyImpl(context, snapshot.data!);
          } else {
            return CircularProgressIndicator();
          }
        },
      );
}
