// import 'package:flutter/cupertino.dart';
// import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
// import 'dart:convert' show json;
import 'package:flutter/cupertino.dart';

import '../../rongcloud_im_plugin.dart';
import 'message_content.dart';
import 'dart:convert' show json;
import '../util/message_factory.dart';
import 'dart:developer' as developer;

//app 层的测试消息
class PromptMessage extends MessageContent {
  static const String objectName = "PromptMessage";

  String content;
  String extra;
  @override
  void decode(String jsonStr) {
    Map map = json.decode(jsonStr.toString());
    debugPrint("PromptMessage--decode---map=$map");
    this.content = map["content"];
    this.extra = map["extra"];

    // decode 消息内容中携带的发送者的用户信息
    Map userMap = map["user"];
    super.decodeUserInfo(userMap);

    // decode 消息中的 @ 提醒信息；消息需要携带 @ 信息时添加此方法
    Map menthionedMap = map["mentionedInfo"];
    super.decodeMentionedInfo(menthionedMap);
  }

  @override
  String encode() {

    Map map = {"content": this.content, "extra": this.extra};
    debugPrint("PromptMessage--encode---map=$map");
    // encode 消息内容中携带的发送者的用户信息
    if (this.sendUserInfo != null) {
      Map userMap = super.encodeUserInfo(this.sendUserInfo);
      map["user"] = userMap;
    }

    // encode 消息中的 @ 提醒信息；消息需要携带 @ 信息时添加此方法
    if (this.mentionedInfo != null) {
      Map mentionedMap = super.encodeMentionedInfo(this.mentionedInfo);
      map["mentionedInfo"] = mentionedMap;
    }
    return json.encode(map);
  }

  @override
  String conversationDigest() {
    return content;
  }

  @override
  String getObjectName() {
    return objectName;
  }
}
