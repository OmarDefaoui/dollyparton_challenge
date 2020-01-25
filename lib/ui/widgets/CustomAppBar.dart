import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:photo_maker/Constants/Constants.dart';
import 'package:photo_maker/models/PopUpMenuItems.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  CustomAppBar({this.title}) : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize; // default is 56.0

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
      ),
      centerTitle: false,
      backgroundColor: Theme.of(context).primaryColor,
      actions: <Widget>[
        PopupMenuButton<PopUpMenuItems>(
          onSelected: (item) {
            showAction(item.title);
          },
          itemBuilder: (BuildContext context) {
            return popUpMenuItems.map((PopUpMenuItems item) {
              return PopupMenuItem<PopUpMenuItems>(
                value: item,
                child: Row(
                  children: <Widget>[
                    Icon(
                      item.icon,
                      color: Colors.lightBlue,
                    ),
                    SizedBox(width: 10),
                    Text(item.title),
                  ],
                ),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  showAction(String title) async {
    switch (title) {
      case 'More apps':
        if (Platform.isAndroid) {
          AndroidIntent intent = AndroidIntent(
            action: 'action_view',
            data: myPlayStoreLink,
          );
          await intent.launch();
        }
        break;
      case 'Share':
        Share.text(shareSubject, shareBody, 'text/plain');
        break;
      case 'Rate':
        if (Platform.isAndroid) {
          AndroidIntent intent = AndroidIntent(
            action: 'action_view',
            data: appPlayStoreLink,
          );
          await intent.launch();
        }
        break;
      case 'Privacy policy':
        if (Platform.isAndroid) {
          AndroidIntent intent = AndroidIntent(
            action: 'action_view',
            data: appPrivacyPolicyLink,
          );
          await intent.launch();
        }
        break;
    }
  }
}
