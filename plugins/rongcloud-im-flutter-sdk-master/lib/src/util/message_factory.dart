import 'dart:core';
import 'dart:convert' show json;
import 'package:rongcloud_im_plugin/src/message/customize_message.dart';
import 'package:rongcloud_im_plugin/src/message/prompt_message.dart';
import '../../rongcloud_im_plugin.dart';
import '../util/type_util.dart';
import 'dart:developer' as developer;

class MessageFactory extends Object {
  factory MessageFactory() => _getInstance();
  static MessageFactory get instance => _getInstance();
  static MessageFactory _instance;
  MessageFactory._internal() {
    // 初始化
  }
  static MessageFactory _getInstance() {
    if (_instance == null) {
      _instance = new MessageFactory._internal();
    }
    return _instance;
  }

  Message string2Message(String msgJsonStr) {
    if (TypeUtil.isEmptyString(msgJsonStr)) {
      return null;
    }
    Map map = json.decode(msgJsonStr);
    return map2Message(map);
  }

  Conversation string2Conversation(String conJsonStr) {
    if (TypeUtil.isEmptyString(conJsonStr)) {
      return null;
    }
    Map map = json.decode(conJsonStr);
    return map2Conversation(map);
  }

  ChatRoomInfo map2ChatRoomInfo(Map map) {
    ChatRoomInfo chatRoomInfo = new ChatRoomInfo();
    chatRoomInfo.targetId = map["targetId"];
    chatRoomInfo.memberOrder = map["memberOrder"];
    chatRoomInfo.totalMemeberCount = map["totalMemeberCount"];
    List memList = new List();
    for (Map memMap in map["memberInfoList"]) {
      memList.add(map2ChatRoomMemberInfo(memMap));
    }
    chatRoomInfo.memberInfoList = memList;
    return chatRoomInfo;
  }

  ChatRoomMemberInfo map2ChatRoomMemberInfo(Map map) {
    ChatRoomMemberInfo chatRoomMemberInfo = new ChatRoomMemberInfo();
    chatRoomMemberInfo.userId = map["userId"];
    chatRoomMemberInfo.joinTime = map["joinTime"];
    return chatRoomMemberInfo;
  }

  Message map2Message(Map map) {
    Message message = new Message();
    message.conversationType = map["conversationType"];
    message.targetId = map["targetId"];
    message.messageId = map["messageId"];
    message.messageDirection = map["messageDirection"];
    message.senderUserId = map["senderUserId"];
    message.receivedStatus = map["receivedStatus"];
    message.sentStatus = map["sentStatus"];
    message.sentTime = map["sentTime"];
    message.objectName = map["objectName"];
    message.messageUId = map["messageUId"];
    message.extra = map["extra"];
    message.canIncludeExpansion = map["canIncludeExpansion"];
    message.expansionDic = map["expansionDic"];
    Map messageConfigMap = map["messageConfig"];
    if (messageConfigMap != null) {
      MessageConfig messageConfig = MessageConfig();
      messageConfig.disableNotification =
          messageConfigMap["disableNotification"];
      message.messageConfig = messageConfig;
    }
    Map readReceiptMap = map["readReceiptInfo"];
    if (readReceiptMap != null) {
      ReadReceiptInfo readReceiptInfo = ReadReceiptInfo();
      readReceiptInfo.isReceiptRequestMessage =
          readReceiptMap["isReceiptRequestMessage"];
      readReceiptInfo.hasRespond = readReceiptMap["hasRespond"];
      readReceiptInfo.userIdList = readReceiptMap["userIdList"];
      message.readReceiptInfo = readReceiptInfo;
    }
    String contenStr = map["content"];
    MessageContent content =
        string2MessageContent(contenStr, message.objectName);
    if (contenStr == null || contenStr == "") {
      developer.log(message.objectName + ":该消息内容为空，可能该消息没有在原生 SDK 中注册",
          name: "RongIMClient.MessageFactory");
      return message;
    }
    if (content != null) {
      message.content = content;
    } else {
      developer.log(
          "${message.objectName}:该消息不能被解析!消息内容被保存在 Message.originContentMap 中",
          name: "RongIMClient.MessageFactory");
      Map map = json.decode(contenStr.toString());
      message.originContentMap = map;
    }
    return message;
  }

  Conversation map2Conversation(Map map) {
    Conversation con = new Conversation();
    con.conversationType = map["conversationType"];
    con.targetId = map["targetId"];
    con.unreadMessageCount = map["unreadMessageCount"];
    con.receivedStatus = map["receivedStatus"];
    con.sentStatus = map["sentStatus"];
    con.sentTime = map["sentTime"];
    con.isTop = map["isTop"];
    con.objectName = map["objectName"];
    con.senderUserId = map["senderUserId"];
    con.latestMessageId = map["latestMessageId"];
    con.mentionedCount = map["mentionedCount"];
    con.draft = map["draft"];

    String contenStr = map["content"];
    MessageContent content = string2MessageContent(contenStr, con.objectName);
    if (content != null) {
      con.latestMessageContent = content;
    } else {
      if (contenStr == null || contenStr.length <= 0) {
        developer.log(
            "该会话没有消息 type:" +
                con.conversationType.toString() +
                " targetId:" +
                con.targetId,
            name: "RongIMClient.MessageFactory");
      } else {
        developer.log(
            con.objectName +
                ":该消息不能被解析!消息内容被保存在 Conversation.originContentMap 中",
            name: "RongIMClient.MessageFactory");
        Map map = json.decode(contenStr.toString());
        con.originContentMap = map;
      }
    }
    return con;
  }

  MessageContent string2MessageContent(String contentS, String objectName) {
    MessageContent content;
    if (objectName == TextMessage.objectName) {
      content = new TextMessage();
      content.decode(contentS);
    } else if (objectName == ImageMessage.objectName) {
      content = new ImageMessage();
      content.decode(contentS);
    } else if (objectName == VoiceMessage.objectName) {
      content = new VoiceMessage();
      content.decode(contentS);
    } else if (objectName == SightMessage.objectName) {
      content = new SightMessage();
      content.decode(contentS);
    } else if (objectName == RecallNotificationMessage.objectName) {
      content = new RecallNotificationMessage();
      content.decode(contentS);
    } else if (objectName == ChatroomKVNotificationMessage.objectName) {
      content = new ChatroomKVNotificationMessage();
      content.decode(contentS);
    } else if (objectName == FileMessage.objectName) {
      content = new FileMessage();
      content.decode(contentS);
    } else if (objectName == RichContentMessage.objectName) {
      content = new RichContentMessage();
      content.decode(contentS);
    } else if (objectName == GifMessage.objectName) {
      content = new GifMessage();
      content.decode(contentS);
    } else if (objectName == CombineMessage.objectName) {
      content = new CombineMessage();
      content.decode(contentS);
    } else if (objectName == ReferenceMessage.objectName) {
      content = new ReferenceMessage();
      content.decode(contentS);
    } else if (objectName == LocationMessage.objectName) {
      content = new LocationMessage();
      content.decode(contentS);
    }
    else if(objectName == PromptMessage.objectName){
      content = new PromptMessage();
      content.decode(contentS);
    }
    else if(objectName == CustomizeMessage.objectName){
      content = new CustomizeMessage();
      content.decode(contentS);
    }
    else if(objectName == EndMessage.objectName){
      content = new EndMessage();
      content.decode(contentS);
    }
    return content;
  }

  Map messageContent2Map(MessageContent content) {
    Map map = new Map();
    return map;
  }

  Map message2Map(Message message) {
    Map map = new Map();
    map["conversationType"] = message.conversationType;
    map["targetId"] = message.targetId;
    map["messageId"] = message.messageId;
    map["messageDirection"] = message.messageDirection;
    map["senderUserId"] = message.senderUserId;
    map["receivedStatus"] = message.receivedStatus;
    map["sentStatus"] = message.sentStatus;
    map["sentTime"] = message.sentTime;
    map["objectName"] = message.objectName;
    map["messageUId"] = message.messageUId;
    if (message.content != null) {
      map["content"] = message.content.encode();
    }
    map["extra"] = message.extra ?? "";
    map["canIncludeExpansion"] = message.canIncludeExpansion;
    map["expansionDic"] = message.expansionDic;
    if (message.messageConfig != null) {
      Map messageConfig = Map();
      messageConfig["disableNotification"] =
          message.messageConfig.disableNotification;
      map["messageConfig"] = messageConfig;
    }
    if (message.readReceiptInfo != null) {
      Map readReceiptMap = Map();
      readReceiptMap["isReceiptRequestMessage"] =
          message.readReceiptInfo.isReceiptRequestMessage;
      readReceiptMap["hasRespond"] = message.readReceiptInfo.hasRespond;
      readReceiptMap["userIdList"] = message.readReceiptInfo.userIdList;
      map["readReceiptInfo"] = readReceiptMap;
    }

    return map;
  }

  TypingStatus string2TypingStatus(String statusJsonStr) {
    if (TypeUtil.isEmptyString(statusJsonStr)) {
      return null;
    }
    Map map = json.decode(statusJsonStr);
    return map2TypingStatus(map);
  }

  TypingStatus map2TypingStatus(Map map) {
    TypingStatus status = new TypingStatus();
    status.userId = map["userId"];
    status.typingContentType = map["typingContentType"];
    status.sentTime = map["sentTime"];
    return status;
  }

  SearchConversationResult string2SearchConversationResult(String resultStr) {
    if (TypeUtil.isEmptyString(resultStr)) {
      return null;
    }
    Map map = json.decode(resultStr);
    return map2SearchConversationResult(map);
  }

  SearchConversationResult map2SearchConversationResult(Map map) {
    SearchConversationResult result = new SearchConversationResult();
    result.mConversation = string2Conversation(map["mConversation"]);
    result.mMatchCount = map["mMatchCount"];
    return result;
  }
}
