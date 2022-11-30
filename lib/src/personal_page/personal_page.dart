// TODO 11.2 实现此类.
import 'package:flutter/material.dart';
import 'package:project_soe/src/login/login_screen.dart';
import 'package:project_soe/src/login/authorition.dart';
import 'package:project_soe/src/personal_page/personal_data.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});
  static const String routeName = 'personal';

  Widget _buildUnloggedinPage(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (!AuthritionState.get().hasToken()) {
          Navigator.pushNamed(context, LoginScreen.routeName);
        }
      },
      child: Text('点击登录'),
    );
  }

  Widget _buildLoggedinPage(BuildContext context) {
    return FutureBuilder<PersonalData?>(
      future: fetchPersonalData(AuthritionState.get().getToken()!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return Column();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthritionState.get().hasToken()
        ? _buildLoggedinPage(context)
        : _buildUnloggedinPage(context);
  }
}
