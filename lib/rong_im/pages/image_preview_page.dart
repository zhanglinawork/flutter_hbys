import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import '../util/media_util.dart';
///图片预览页面
class ImagePreviewPage extends StatefulWidget {
  final Message message;
  const ImagePreviewPage({Key key, this.message}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ImagePreviewPageState(message);
  }
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  final Message message;
  _ImagePreviewPageState(this.message);

  //优先加载本地路径图片，否则加载网络图片
  Widget getImageWidget() {
    String localPath;
    String remoteUrl;
    if(message != null) {
      if (message.content is GifMessage) {
        GifMessage msg = message.content;
        localPath = msg.localPath;
        remoteUrl = msg.remoteUrl;
      }
      else if(message.content is ImageMessage){
        ImageMessage msg = message.content;
        localPath = msg.localPath;
        remoteUrl = msg.imageUri;
      }
      else {
        localPath =message.extra;
        remoteUrl = message.extra;
      }
    }
    Widget widget;
    if (localPath != null) {
      String path = MediaUtil.instance.getCorrectedLocalPath(localPath);
      File file = File(path);
      if (file != null && file.existsSync()) {
        widget = Image.file(file);
      } else {
        widget = Image.network(
          remoteUrl,
          fit: BoxFit.fitWidth,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
                child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes
                    : null,
              ),
            );
          },
        );
      }
    } else {
      widget = Image.network(
        remoteUrl,
        fit: BoxFit.fitWidth,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        },
      );
    }
    return widget;
    // return container;
  }

  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child:
            Container(
              width: double.infinity,
              height: 70,
              margin:EdgeInsets.only(left: 10) ,
              alignment: Alignment.bottomLeft,

            child: Image.asset("assets/images/navigation_back.png",width: 30,height: 30,),
            )

          ),
          Expanded(
            child:Container(
              height: double.infinity,
              child: getImageWidget(),
            ) ,
          )

        ],
      );

  }
}
