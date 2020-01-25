import 'dart:io';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:photo_maker/Constants/Constants.dart';
import 'package:photo_maker/ui/widgets/CustomAppBar.dart';
import 'package:photo_maker/ui/widgets/ImageCard.dart';
import 'package:screenshot/screenshot.dart';

class PhotoCreator extends StatefulWidget {
  @override
  _PhotoCreatorState createState() => _PhotoCreatorState();
}

class _PhotoCreatorState extends State<PhotoCreator> {
  double _width = 0;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Photo Creator',
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Screenshot(
              controller: screenshotController,
              child: Container(
                width: _width,
                height: _width,
                color: Colors.red,
                child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(4, (index) {
                    return ImageCard(
                      index: index,
                    );
                  }),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                child: Text(
                  "Share",
                ),
                onPressed: _shareImage,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _shareImage() {
    screenshotController.capture().then((File image) async {
      print("Capture Done");

      try {
        await Share.file('Share result', 'quiz_result.png',
            image.readAsBytesSync().buffer.asUint8List(), 'image/png',
            text: '$shareBody');
      } catch (e) {
        print('error: $e');
      }
    }).catchError((onError) {
      print(onError);
    });
  }
}
