import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCard extends StatefulWidget {
  final int index;
  ImageCard({this.index});

  @override
  _ImageCardState createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  File _image;
  double _width;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;

    return Container(
      width: _width / 2,
      height: _width / 2,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              child: InkWell(
                child: Image(
                  image: _displayImage(),
                ),
                onTap: _handleImage,
              ),
            ),
          ),
          Positioned.fill(
            bottom: _width / 150,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: _textWithStroke(
                text: _displayText(),
                fontSize: _width / 18,
                fontWeight: FontWeight.w500,
                strokeColor: Colors.black,
                textColor: Colors.white,
                strokeWidth: _width / 120,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _displayImage() {
    if (_image != null)
      return FileImage(_image);
    else
      return AssetImage(
        'assets/images/add.png',
      );
  }

  _handleImage() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      imageFile = await _cropImage(imageFile);
      setState(() {
        _image = imageFile;
      });
    }
  }

  _cropImage(File imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    return croppedImage;
  }

  Widget _textWithStroke(
      {String text,
      double fontSize,
      FontWeight fontWeight,
      double strokeWidth,
      Color textColor: Colors.white,
      Color strokeColor: Colors.black}) {
    return Stack(
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
      ],
    );
  }

  _displayText() {
    switch (widget.index) {
      case 0:
        return 'Facebook';
      case 1:
        return 'Instagram';
      case 2:
        return 'LinkedIn';
      case 3:
        return 'Tinder';
    }
  }
}
