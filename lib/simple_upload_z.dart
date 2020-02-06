import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef PickerConfirmCallback = void Function(TakeWay type, File file);

class ZSimpleUpload {
  final PickerConfirmCallback onSuccessFunc;
  final TextStyle labelStyle;
  final TakeWay takeWay;

  ZSimpleUpload({
    @required this.onSuccessFunc,
    this.takeWay = TakeWay.phpto,
    this.labelStyle = const TextStyle(fontSize: 14),
  });

  _openGallery(TakeWay takeway, ImageSource type) async {
    File file;
    if (takeway == TakeWay.phpto) {
      file = await ImagePicker.pickImage(source: type);
    } else if (takeway == TakeWay.video) {
      file = await ImagePicker.pickVideo(source: type);
    }

    if (file == null) {
      return;
    }
    onSuccessFunc(takeway, file);
  }


  Future<T> showModal<T>(BuildContext ctx) async {
    return await showCupertinoModalPopup(
      context: ctx,
      builder: (ctx) {
        return CupertinoActionSheet(
          actions: <Widget>[
            takeWay == TakeWay.video ? SizedBox() : CupertinoActionSheetAction(
              child: Text(
                '从相册选择图片',
                style: labelStyle,
              ),
              onPressed: () {
                Navigator.pop(ctx);
                _openGallery(TakeWay.phpto, ImageSource.gallery);
              },
            ),
            takeWay == TakeWay.phpto ? SizedBox() : CupertinoActionSheetAction(
              child: Text(
                '从相册选择视频',
                style: labelStyle,
              ),
              onPressed: () {
                Navigator.pop(ctx);
                _openGallery(TakeWay.video, ImageSource.gallery);
              },
            ),
            takeWay == TakeWay.video ? SizedBox() : CupertinoActionSheetAction(
              child: Text(
                '拍照',
                style: labelStyle,
              ),
              onPressed: () {
                Navigator.pop(ctx);
                _openGallery(TakeWay.phpto, ImageSource.camera);
              },
            ),
            takeWay == TakeWay.phpto ? SizedBox() : CupertinoActionSheetAction(
              child: Text(
                '拍摄视频',
                style: labelStyle,
              ),
              onPressed: () {
                Navigator.pop(ctx);
                _openGallery(TakeWay.video, ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }
}

enum TakeWay { video, phpto, all }
