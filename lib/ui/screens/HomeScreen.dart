import 'dart:math';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:dolly_parton_challenge/Constants/AdmobId.dart';
import 'package:dolly_parton_challenge/Constants/Constants.dart';
import 'package:dolly_parton_challenge/models/PopUpMenuItems.dart';
import 'package:dolly_parton_challenge/ui/screens/PhotoCreator.dart';
import 'package:dolly_parton_challenge/ui/widgets/FancyBackground.dart';
import 'package:dolly_parton_challenge/ui/widgets/ShowActions.dart';
import 'package:dolly_parton_challenge/utilities/adBuilder.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  double _height;
  bool _isInterstitialAdLoaded = false;

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
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              alignment: Alignment.center,
              child: Text(
                appDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  shadows: [
                    BoxShadow(
                      blurRadius: 25,
                      color: Colors.grey.shade300,
                      offset: Offset(0, 0.2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            bottom: _height / 9,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Participate'),
                    SizedBox(width: 10),
                    Icon(Icons.navigate_next),
                  ],
                ),
                onPressed: () {
                  //close  banner
                  try {
                    _bannerAd?.dispose();
                  } catch (error) {}

                  //open interstitial ad
                  if (_isInterstitialAdLoaded) {
                    _isInterstitialAdLoaded = false;
                    _interstitialAd..show();
                  }

                  //navigate to next page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhotoCreator(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );

  _initAds() {
    FirebaseAdMob.instance.initialize(appId: admobAppId);
    _bannerAd = createBannerAd(1)
      ..load()
      ..show();

    _interstitialAd = createInterstitialAd(1)
      ..load().then((value) {
        if (value) _isInterstitialAdLoaded = true;
      });
  }
}
