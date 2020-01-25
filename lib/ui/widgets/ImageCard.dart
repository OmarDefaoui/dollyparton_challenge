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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      margin: EdgeInsets.all(2),
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
            child: Container(
              alignment: Alignment.bottomCenter,
              child: _textWithStroke(
                text: 'Item ${widget.index}',
                fontSize: 26,
                fontWeight: FontWeight.w500,
                strokeColor: Colors.black,
                textColor: Colors.white,
                strokeWidth: 5.5,
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
      return AssetImage('assets/images/user_placeholder.jpg');
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
}
