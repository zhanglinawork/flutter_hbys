import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import 'dart:convert' show json;

//app 层的测试消息
class CustomizeMessage extends MessageContent {
  static const String objectName = "CustomizeMessage";

   String name;
   String age;
   String gender;
   String desc;
   String order_id;
   String img;
   String serviceId;
   List<String> first_images;
   String extra;


  @override
  void decode(String jsonStr) {
    Map map = json.decode(jsonStr.toString());
    this.name = map["name"];
    this.age = map["age"];
    this.gender = map["gender"];
    this.desc = map["desc"];
    this.order_id = map["order_id"];
    this.img = map["img"];
    this.serviceId = map["serviceId"];
    this.first_images = map["first_images"];
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
    Map map = {"name":this.name,"age":this.age,
      "gender":this.gender,"desc":this.desc,"order_id":this.order_id,"img":this.img,
      "serviceId":this.serviceId,"first_images":this.first_images,
      "extra": this.extra};

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
    return "首问消息";
  }

  @override
  String getObjectName() {
    return objectName;
  }
}
