import 'package:flutter/material.dart';
import 'package:project_soe/CComponents/ComponentAppBar.dart';
import 'package:project_soe/CComponents/ComponentBottomNavigation.dart';
import 'package:project_soe/CComponents/ComponentTitle.dart';
import 'package:project_soe/GGlobalParams/Styles.dart';
import 'package:project_soe/VMistakeBook/DataMistakeBook.dart';

class ViewMistakeDetail extends StatelessWidget {
  static String routeName = 'mistakeDetail';
  ViewMistakeDetail();
  Widget _buildImpl(BuildContext context, DataMistakeDetail mistakeDetail) {
    List<Widget> children = List.empty(growable: true);
    for (final detailItem in mistakeDetail.listMistakeDetail) {
      children.add(_buildItem(detailItem));
    }
    return ListView(
      children: children,
    );
  }

  Widget _buildItem(DataMistakeDetailListItem listItem) {
    return ComponentTitle(
      label: 'cpsrcdId${listItem.cpsrcdId!}',
      style: gTitleStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List<int>;
    int oneWeekKey = args[0];
    int mistakeTypeCode = args[1];
    return FutureBuilder<DataMistakeDetail>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: gColorE3EDF7RGBA,
            appBar: ComponentAppBar(
              title: ComponentTitle(label: "错题详情", style: gTitleStyle),
              hasBackButton: true,
            ),
            body: _buildImpl(context, snapshot.data!),
            bottomNavigationBar: ComponentBottomNavigator(
                curRouteName: ViewMistakeDetail.routeName),
          );
        } else {
          return Scaffold(
            backgroundColor: gColorE3EDF7RGBA,
            appBar: ComponentAppBar(
              title: ComponentTitle(label: "错题详情", style: gTitleStyle),
              hasBackButton: true,
            ),
            body: CircularProgressIndicator(),
            bottomNavigationBar: ComponentBottomNavigator(
                curRouteName: ViewMistakeDetail.routeName),
          );
        }
      },
      future: postGetDataMistakeDetail(mistakeTypeCode, oneWeekKey),
    );
  }
}
