import 'package:flutter/material.dart';
import 'package:project_soe/VAuthorition/DataAuthorition.dart';
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';

class ComponentAppBar extends StatelessWidget implements PreferredSizeWidget {
  Widget? title;
  ComponentAppBar({super.key, this.title});

  Widget _buildImpl(BuildContext context, DataUserInfo info) {
    return Container(
      height: 125.0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30, bottom: 20),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(info.avatarUri),
                ),
              ),
              (title != null)
                  ? title!
                  : Padding(
                      padding: EdgeInsets.only(left: 50.0),
                    ),
              Padding(
                padding: EdgeInsets.only(right: 30, bottom: 20),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.apps),
                ),
              ),
            ],
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(125.0);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataUserInfo>(
      future: AuthritionState.instance.getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildImpl(context, snapshot.data!);
        } else {
          return AppBar(
            automaticallyImplyLeading: false,
          );
        }
      },
    );
  }
}
