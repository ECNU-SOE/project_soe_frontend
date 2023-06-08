import 'package:flutter/material.dart';
import 'package:project_soe/VAuthorition/DataAuthorition.dart';
import 'package:project_soe/VAuthorition/LogicAuthorition.dart';
import 'package:project_soe/s_o_e_icons_icons.dart';

class ComponentAppBar extends StatelessWidget implements PreferredSizeWidget {
  Widget? title;
  bool hasBackButton;
  ComponentAppBar({super.key, this.title, this.hasBackButton = false});

  Widget _buildImpl(BuildContext context, DataUserInfo info) {
    return Container(
      height: 100.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              hasBackButton
                  ? Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        bottom: 10,
                      ),
                      child: Center(
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          iconSize: 35,
                          color: Color(0xff23529A),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  bottom: 10,
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(info.avatarUri),
                ),
              ),
              Spacer(),
              (title != null)
                  ? Center(
                      child: title!,
                    )
                  : Spacer(),
              Spacer(),
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
