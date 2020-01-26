import 'dart:io';
import 'dart:math';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:dolly_parton_challenge/Constants/AdmobId.dart';
import 'package:dolly_parton_challenge/Constants/Constants.dart';
import 'package:dolly_parton_challenge/models/PopUpMenuItems.dart';
import 'package:dolly_parton_challenge/ui/widgets/FancyBackground.dart';
import 'package:dolly_parton_challenge/ui/widgets/ImageCard.dart';
import 'package:dolly_parton_challenge/ui/widgets/ShowActions.dart';
import 'package:dolly_parton_challenge/utilities/adBuilder.dart';
import 'package:screenshot/screenshot.dart';

class PhotoCreator extends StatefulWidget {
  @override
  _PhotoCreatorState createState() => _PhotoCreatorState();
}

class _PhotoCreatorState extends State<PhotoCreator> {
  double _width, _height = 0;
  ScreenshotController screenshotController = ScreenshotController();
  bool _isLoading = false;

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  @override
  void initState() {
    super.initState();
    _initAds();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(child: AnimatedBackground()),
          onBottom(
            AnimatedWave(
              height: 180,
              speed: 1.0,
            ),
          ),
          onBottom(
            AnimatedWave(
              height: 120,
              speed: 0.9,
              offset: pi,
            ),
          ),
          onBottom(
            AnimatedWave(
              height: 220,
              speed: 1.2,
              offset: pi / 2,
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.topRight,
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {},
                  child: PopupMenuButton<PopUpMenuItems>(
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
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.topLeft,
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),
          Center(
            child: Screenshot(
              controller: screenshotController,
              child: Container(
                width: _width,
                height: _width,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Wrap(
                    children: <Widget>[
                      ImageCard(index: 0),
                      ImageCard(index: 1),
                      ImageCard(index: 2),
                      ImageCard(index: 3),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: _height / 12,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            "Save to gallery",
                          ),
                          onPressed: _saveImageToGallery,
                        ),
                        RaisedButton(
                          child: Text(
                            "Share",
                          ),
                          onPressed: _shareImage,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  _shareImage() {
    setState(() {
      _isLoading = true;
    });
    screenshotController.capture().then((File image) async {
      print("Capture Done");

      try {
        await Share.file('Share', 'image_result.png',
            image.readAsBytesSync().buffer.asUint8List(), 'image/png',
            text: '$shareBody');

        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print('error: $e');
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  _saveImageToGallery() {
    setState(() {
      _isLoading = true;
    });
    screenshotController.capture().then((File image) async {
      print("Capture Done");

      try {
        final result = await ImageGallerySaver.saveImage(
            image.readAsBytesSync().buffer.asUint8List());
        print(result);

        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print('error: $e');
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );

  _initAds() {
    FirebaseAdMob.instance.initialize(appId: admobAppId);
    _bannerAd = createBannerAd(2)
      ..load()
      ..show();

    Future.delayed(const Duration(seconds: 2), () {
      _interstitialAd = createInterstitialAd(2)
        ..load()
        ..show();
    });
  }
}
