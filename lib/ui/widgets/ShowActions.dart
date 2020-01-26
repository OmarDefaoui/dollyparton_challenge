import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:dolly_parton_challenge/Constants/Constants.dart';

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
