import 'dart:io';
import 'dart:math';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:dolly_parton_challenge/Constants/AdmobId.dart';
import 'package:dolly_parton_challenge/Constants/Constants.dart';
import 'package:dolly_parton_challenge/models/PopUpMenuItems.dart';
import 'package:dolly_parton_challenge/ui/widgets/FancyBackground.dart';
import 'package:dolly_parton_challenge/ui/widgets/ImageCard.dart';
import 'package:dolly_parton_challenge/ui/widgets/ShowActions.dart';
import 'package:dolly_parton_challenge/utilities/adBuilder.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoCreator extends StatefulWidget {
  @override
  _PhotoCreatorState createState() => _PhotoCreatorState();
}

class _PhotoCreatorState extends State<PhotoCreator> {
  double _width, _height = 0;
  ScreenshotController screenshotController = ScreenshotController();
  bool _isLoading = false,
      _isSavedToGallery = false,
      _isInterstitialAdLoaded = false;

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  @override
  void initState() {
    super.initState();
    _askForPermission();
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
                            _isSavedToGallery ? 'Saved' : "Save to gallery",
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

  _shareImage() async {
    _showInterstitialAd();
    setState(() {
      _isLoading = true;
    });
    screenshotController.capture().then((File image) async {
      print("Capture Done");
      File _image = image;

      try {
        await Share.file('Share', 'image_result.png',
            _image.readAsBytesSync().buffer.asUint8List(), 'image/png',
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

  _saveImageToGallery() async {
    _showInterstitialAd();
    setState(() {
      _isLoading = true;
    });

    screenshotController.capture().then((File image) async {
      print("Capture Done");
      File _image = image;
      print('${_image.path}');

      try {
        GallerySaver.saveImage(_image.path).then((bool result) {
          print('res: $result');
          setState(() {
            if (result) _isSavedToGallery = true;
            _isLoading = false;
          });
        });
      } catch (e) {
        print('error: $e');
      }
    }).catchError((onError) {
      print('error: $onError');
      print(onError);
    });
  }

  onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );

  _askForPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);

    print('${permissions[PermissionGroup.storage]}');
    if (permissions[PermissionGroup.storage] != PermissionStatus.granted)
      _showConfirmationDialog();
  }

  _showConfirmationDialog() {
    showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            content: Text(
              "This permission is required to select and save images to gallery.",
            ),
            title: Text("Warning !"),
            actions: <Widget>[
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Accept"),
                onPressed: () {
                  Navigator.pop(context, true);
                  _askForPermission();
                },
              ),
            ],
          );
        });
  }

  _initAds() {
    FirebaseAdMob.instance.initialize(appId: admobAppId);
    _bannerAd = createBannerAd(2)
      ..load()
      ..show();

    _interstitialAd = createInterstitialAd(2)
      ..load().then((value) {
        if (value) _isInterstitialAdLoaded = true;
      });
  }

  void _showInterstitialAd() {
    if (_isInterstitialAdLoaded) {
      _isInterstitialAdLoaded = false;
      _interstitialAd..show();
    }
  }
}
