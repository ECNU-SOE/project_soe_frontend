import 'package:flutter/material.dart';
import 'package:project_soe/VMistakeBook/DataMistake.dart';

class ViewMistakeDetail extends StatelessWidget {
  static String routeName = 'mistakeDetail';
  ViewMistakeDetail();
  Widget _buildImpl(BuildContext context, DataMistakeDetail mistakeDetail) {
    // TODO
    return ListView();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List<int>;
    int oneWeekKey = args[0];
    int mistakeTypeCode = args[1];
    return FutureBuilder<DataMistakeDetail>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildImpl(context, snapshot.data!);
        } else {
          return CircularProgressIndicator();
        }
      },
      future: postGetDataMistakeDetail(mistakeTypeCode, oneWeekKey),
    );
  }
}
