import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hbys/widgets/my_colors.dart';
import 'package:flutter_hbys/widgets/recorder_widget.dart';
import 'widget_util.dart';
import '../../widget/cachImage/cached_image_widget.dart';

import '../../util/media_util.dart';
import '../../util/style.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import '../../util/user_info_datesource.dart' as example;
import 'dart:developer' as developer;

class BottomInputBar extends StatefulWidget {
  BottomInputBarDelegate delegate;
  _BottomInputBarState state;

  BottomInputBar(BottomInputBarDelegate delegate) {
    this.delegate = delegate;
  }

  @override
  _BottomInputBarState createState() =>
      state = _BottomInputBarState(this.delegate);

  void setTextContent(String textContent) {
    this.state.setText(textContent);
  }

  void refreshUI() {
    this.state._refreshUI();
  }

  void makeReferenceMessage(Message message) {
    this.state.makeReferenceMessage(message);
  }

  ReferenceMessage getReferenceMessage() {
    return this.state.referenceMessage;
  }

  void clearReferenceMessage() {
    this.state.clearReferenceMessage();
  }
}

class _BottomInputBarState extends State<BottomInputBar> {
  String pageName = "example.BottomInputBar";
  BottomInputBarDelegate delegate;
  TextField textField;
  FocusNode focusNode = FocusNode();
  InputBarStatus inputBarStatus;
  TextEditingController textEditingController;
  Message message;
  ReferenceMessage referenceMessage;
  example.UserInfo referenceUserInfo;

  _BottomInputBarState(BottomInputBarDelegate delegate) {
    this.delegate = delegate;
    this.inputBarStatus = InputBarStatus.Normal;
    this.textEditingController = TextEditingController();
    textEditingController.clear();
    this.textField = TextField(
      onSubmitted: _clickSendMessage,
      controller: textEditingController,
      decoration: InputDecoration(
        border: InputBorder.none,
        // hintText: RCString.BottomInputTextHint
      ),
      focusNode: focusNode,
      autofocus: false,
      maxLines: null,
      keyboardType: TextInputType.text,
    );
  }

  void setText(String textContent) {
    if (textContent == null) {
      textContent = '';
    }
    this.textEditingController.text =
        this.textEditingController.text + textContent;
    this.textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));
    _refreshUI();
  }

  void _refreshUI() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    textEditingController.text = "";
    textEditingController.addListener(() {
      //获取输入的值
      delegate.onTextChange(textEditingController.text);
    });
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        _notifyInputStatusChanged(InputBarStatus.Normal);
      }
    });
  }

  void _clickSendMessage(String messageStr) {
    if (messageStr == null || messageStr.length <= 0) {
      developer.log("clickSendMessage MessageStr 不能为空", name: pageName);
      return;
    }

    if (this.delegate != null) {
      this.delegate.willSendText(messageStr);
    } else {
      developer.log("没有实现 BottomInputBarDelegate", name: pageName);
    }
    this.textField.controller.text = '';
  }

  switchPhrases() {
    developer.log("switchPhrases", name: pageName);
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
    InputBarStatus status = InputBarStatus.Normal;
    if (this.inputBarStatus != InputBarStatus.Phrases) {
      status = InputBarStatus.Phrases;
    }
    _notifyInputStatusChanged(status);
  }

  switchVoice() {
    developer.log("switchVoice", name: pageName);
    InputBarStatus status = InputBarStatus.Normal;
    if (this.inputBarStatus != InputBarStatus.Voice) {
      status = InputBarStatus.Voice;
    }
    _notifyInputStatusChanged(status);
  }

  switchEmoji() {
    developer.log("switchEmoji", name: pageName);
    InputBarStatus status = InputBarStatus.Normal;
    if (this.inputBarStatus != InputBarStatus.Emoji) {
      if (focusNode.hasFocus) {
        focusNode.unfocus();
      }
      status = InputBarStatus.Emoji;
    }
    _notifyInputStatusChanged(status);
  }

  switchExtention() {
    developer.log("switchExtention", name: pageName);
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
    InputBarStatus status = InputBarStatus.Normal;
    if (this.inputBarStatus != InputBarStatus.Extention) {
      status = InputBarStatus.Extention;
    }
    if (this.delegate != null) {
      this.delegate.didTapExtentionButton();
    } else {
      developer.log("没有实现 BottomInputBarDelegate", name: pageName);
    }
    _notifyInputStatusChanged(status);
  }

  _onVoiceGesLongPress() {
    developer.log("_onVoiceGesLongPress", name: pageName);
    MediaUtil.instance.startRecordAudio();
    if (this.delegate != null) {
      this.delegate.willStartRecordVoice();
    } else {
      developer.log("没有实现 BottomInputBarDelegate", name: pageName);
    }
  }

  _onVoiceGesLongPressEnd() {
    developer.log("_onVoiceGesLongPressEnd", name: pageName);

    if (this.delegate != null) {
      this.delegate.willStopRecordVoice();
    } else {
      developer.log("没有实现 BottomInputBarDelegate", name: pageName);
    }

    MediaUtil.instance.stopRecordAudio((String path, int duration) {
      if (this.delegate != null && path.length > 0) {
        this.delegate.willSendVoice(path, duration);
      } else {
        developer.log("没有实现 BottomInputBarDelegate || 录音路径为空", name: pageName);
      }
    });
  }

  _onVoiceGesLongPressEnd2(String path, int duration) {
    developer.log("_onVoiceGesLongPressEnd2", name: pageName);

    if (this.delegate != null) {
      this.delegate.willStopRecordVoice();
    } else {
      developer.log("没有实现 BottomInputBarDelegate", name: pageName);
    }
    if (this.delegate != null && path.length > 0) {
      this.delegate.willSendVoice(path, duration);
    } else {
      developer.log("没有实现 BottomInputBarDelegate || 录音路径为空", name: pageName);
    }
  }

  Widget _getMainInputField() {
    Widget widget;
    if (this.inputBarStatus == InputBarStatus.Voice) {
      widget = Container(
        alignment: Alignment.center,
        child: RecorderWidget(
          stopRecord: (path,duration){
            _onVoiceGesLongPressEnd2(path, duration);
          },
        ),
        // child: GestureDetector(
        //   behavior: HitTestBehavior.opaque,
        //   child: Text(RCString.BottomTapSpeak, textAlign: TextAlign.center,style: TextStyle(
        //     fontSize: 15,color: MyColors.color_333333
        //   ),),
        //   onLongPress: () {
        //     _onVoiceGesLongPress();
        //   },
        //   onLongPressEnd: (LongPressEndDetails details) {
        //     _onVoiceGesLongPressEnd();
        //   },
        // ),
      );
    } else {
      widget = Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: new ConstrainedBox(
          constraints: BoxConstraints(
              // maxHeight: 200.0,
              ),
          child: new SingleChildScrollView(
            scrollDirection: Axis.vertical,
            reverse: true,
            child: this.textField,
          ),
        ),
      );
    }
    return Container(
      height: 36,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: MyColors.color_d9d9d9,
                border:
                    new Border.all(color: MyColors.color_d9d9d9, width: 0.5),
                borderRadius: BorderRadius.circular(4)),
          ),
          widget
        ],
      ),
    );
  }

  void _notifyInputStatusChanged(InputBarStatus status) {
    this.inputBarStatus = status;
    if (this.delegate != null) {
      this.delegate.inputStatusDidChange(status);
    } else {
      developer.log("没有实现 BottomInputBarDelegate", name: pageName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              referenceMessage == null
                  ? WidgetUtil.buildEmptyWidget()
                  : _buildReferenceWidget(),
              // GestureDetector(
              //     onTap: () {
              //       switchPhrases();
              //     },
              //     child: Container(
              //       padding: EdgeInsets.fromLTRB(6, 6, 12, 6),
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(5),
              //         child: Container(
              //           alignment: Alignment.center,
              //           width: 80,
              //           height: 22,
              //           color: Color(0xffC8C8C8),
              //           child: Text(
              //             RCString.BottomCommonPhrases,
              //             style: TextStyle(color: Colors.white, fontSize: 14),
              //           ),
              //         ),
              //       ),
              //     )),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Image.asset(
                      "assets/images/rc_keyboard.png",
                      width: 30,
                      height: 30,
                      fit: BoxFit.fill,
                    ),
                    iconSize: 32,
                    onPressed: () {
                      switchVoice();
                    },
                  ),
                  Expanded(child: _getMainInputField()),
                  IconButton(
                    icon: Image.asset(
                      "assets/images/rc_emotion_toggle.png",
                      width: 30,
                      height: 30,
                      fit: BoxFit.fill,
                    ), // sentiment_ver
                    iconSize: 32,
                    onPressed: () {
                      switchEmoji();
                    },
                  ),
                  IconButton(
                    icon: Image.asset(
                      "assets/images/rc_ext_plugin_toggle.png",
                      width: 30,
                      height: 30,
                      fit: BoxFit.fill,
                    ),
                    iconSize: 32,
                    onPressed: () {
                      switchExtention();
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ]));
  }

  Widget _buildReferenceWidget() {
    return IntrinsicHeight(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        VerticalDivider(
          color: Colors.grey,
          thickness: 3,
        ),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 4, bottom: 2),
                  child: Text(
                      referenceUserInfo == null ? "" : referenceUserInfo.id,
                      style: TextStyle(
                          fontSize: RCFont.BottomReferenceNameSize,
                          color: Color(RCColor.BottomReferenceNameColor)))),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 60.0,
                ),
                child: new SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    reverse: false,
                    child: GestureDetector(
                      child: _buildReferenceContent(),
                      onTap: () {
                        _clickContent();
                      },
                    )),
              )
            ])),
        Container(
            margin: EdgeInsets.only(right: 10),
            height: 30,
            width: 30,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                clearReferenceMessage();
              },
            ))
      ],
    ));
  }

  void _clickContent() {
    if (referenceMessage.referMsg is ImageMessage) {
      // 引用的消息为图片时的点击事件
      Message tempMsg = message;
      tempMsg.content = referenceMessage.referMsg;
      Navigator.pushNamed(context, "/image_preview", arguments: tempMsg);
    } else if (referenceMessage.referMsg is FileMessage) {
      // 引用的消息为文件时的点击事件
      Message tempMsg = message;
      tempMsg.content = referenceMessage.referMsg;
      Navigator.pushNamed(context, "/file_preview", arguments: tempMsg);
    } else if (referenceMessage.referMsg is RichContentMessage) {
      // 引用的消息为图文时的点击事件
      RichContentMessage richContentMessage = referenceMessage.referMsg;
      Map param = {
        "url": richContentMessage.url,
        "title": richContentMessage.title
      };
      Navigator.pushNamed(context, "/webview", arguments: param);
    } else {
      // 引用的消息为文本时的点击事件
    }
  }

  Widget _buildReferenceContent() {
    Widget widget = WidgetUtil.buildEmptyWidget();
    MessageContent messageContent = referenceMessage.referMsg;
    if (messageContent is TextMessage) {
      TextMessage textMessage = messageContent;
      widget = Text(textMessage.content,
          style: TextStyle(
              fontSize: RCFont.BottomReferenceContentSize,
              color: Color(RCColor.BottomReferenceContentColor)));
    } else if (messageContent is ImageMessage) {
      ImageMessage imageMessage = messageContent;
      Widget imageWidget;
      if (imageMessage.content != null && imageMessage.content.length > 0) {
        Uint8List bytes = base64.decode(imageMessage.content);
        imageWidget = Image.memory(bytes);
      } else {
        if (imageMessage.localPath != null) {
          String path =
              MediaUtil.instance.getCorrectedLocalPath(imageMessage.localPath);
          File file = File(path);
          if (file != null && file.existsSync()) {
            imageWidget = Image.file(file);
          } else {
            imageWidget = CachedNetworkImage(
              progressIndicatorBuilder: (context, url, progress) =>
                  CircularProgressIndicator(
                value: progress.progress,
              ),
              imageUrl: imageMessage.imageUri,
            );
          }
        } else {
          imageWidget = CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) =>
                CircularProgressIndicator(
              value: progress.progress,
            ),
            imageUrl: imageMessage.imageUri,
          );
        }
      }
      widget = Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 150,
        ),
        child: imageWidget,
      );
    } else if (messageContent is FileMessage) {
      FileMessage fileMessage = messageContent;
      widget = Text("[文件] ${fileMessage.mName}",
          style: TextStyle(
              fontSize: RCFont.BottomReferenceContentSize,
              color: Color(RCColor.BottomReferenceContentColorFile)));
    } else if (messageContent is RichContentMessage) {
      RichContentMessage richContentMessage = messageContent;
      widget = Text("[图文] ${richContentMessage.title}",
          style: TextStyle(
              fontSize: RCFont.BottomReferenceContentSize,
              color: Color(RCColor.BottomReferenceContentColorFile)));
    } else if (messageContent is ReferenceMessage) {
      ReferenceMessage referenceMessage = messageContent;
      widget = Text(referenceMessage.content,
          style: TextStyle(
              fontSize: RCFont.BottomReferenceContentSize,
              color: Color(RCColor.BottomReferenceContentColorFile)));
    }
    return widget;
  }

  void setInfo(String userId) {
    example.UserInfo userInfo =
        example.UserInfoDataSource.cachedUserMap[userId];
    if (userInfo != null) {
      this.referenceUserInfo = userInfo;
    } else {
      example.UserInfoDataSource.getUserInfo(userId).then((onValue) {
        setState(() {
          this.referenceUserInfo = onValue;
        });
      });
    }
  }

  void makeReferenceMessage(Message message) {
    if (message != null) {
      this.message = message;
      referenceMessage = ReferenceMessage();
      referenceMessage.referMsgUserId = message.senderUserId;
      if (message.content is ReferenceMessage) {
        ReferenceMessage content = message.content;
        TextMessage textMessage = TextMessage.obtain(content.content);
        referenceMessage.referMsg = textMessage;
      } else {
        referenceMessage.referMsg = message.content;
      }
      setInfo(referenceMessage.referMsgUserId);
    } else {
      referenceMessage = null;
    }
    _refreshUI();
  }

  ReferenceMessage getReferenceMessage() {
    return referenceMessage;
  }

  void clearReferenceMessage() {
    referenceMessage = null;
    message = null;
    _refreshUI();
  }
}

enum InputBarStatus {
  Normal, //正常
  Voice, //语音输入
  Extention, //扩展栏
  Phrases, //快捷回复
  Emoji, // emoji输入
}

abstract class BottomInputBarDelegate {
  ///输入工具栏状态发生变更
  void inputStatusDidChange(InputBarStatus status);

  ///即将发送消息
  void willSendText(String text);

  ///即将发送语音
  void willSendVoice(String path, int duration);

  ///即将开始录音
  void willStartRecordVoice();

  ///即将停止录音
  void willStopRecordVoice();

  ///点击了加号按钮
  void didTapExtentionButton();

  ///输入框内容变化监听
  void onTextChange(String text);
}
