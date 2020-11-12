import 'dart:async';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hbys/generated/l10n.dart';
import 'package:flutter_plugin_baseframwork/base_framework/utils/image_helper.dart';
import 'package:flutter_plugin_record/index.dart';

typedef startRecord = Future Function();
typedef stopRecord = Future Function();

///录音控件(仿微信录音功能)
class RecorderWidget extends StatefulWidget {
  final Function startRecord;
  final Function stopRecord;
  /// startRecord 开始录制回调  stopRecord回调
  const RecorderWidget({Key key, this.startRecord, this.stopRecord})
      : super(key: key);

  @override
  _RecorderWidgetState createState() => _RecorderWidgetState();
}

class _RecorderWidgetState extends State<RecorderWidget> {
  double starty = 0.0;
  double offset = 0.0;
  bool isUp = false;
  bool isTooShort = false;
  String textShow = "按住说话";
  String toastShow = "手指上滑,取消发送";
  String voiceIco = ImageHelper.wrapAssets("voicelib_ic_volume_1");
  String cancleIco =
      ImageHelper.wrapAssets("voicelib_ic_volume_cancel"); //手指滑动到按钮之外时显示该图片
  String timeShortIco =
      ImageHelper.wrapAssets("voicelib_ic_volume_wraning"); //录音时间过短时显示到图片

  ///默认隐藏状态
  bool voiceState = true;
  OverlayEntry overlayEntry; //录音时的悬浮框（仿微信）
  FlutterPluginRecord recordPlugin; //录音插件

  Timer _timer; //倒计时，限制最多录制1分钟
  int curentTimer = 60;

  @override
  void initState() {
    super.initState();
    recordPlugin = new FlutterPluginRecord();

    _init();

    ///初始化方法的监听
    recordPlugin.responseFromInit.listen((data) {
      if (data) {
        print("初始化成功");
      } else {
        print("初始化失败");
      }
    });

    /// 开始录制或结束录制的监听
    recordPlugin.response.listen((data) {
      if (data.msg == "onStop") {
        debugPrint("isUp===$isUp");
        if (_timer != null) {
          _timer.cancel();
          _timer = null;
        }

        ///结束录制时会返回录制文件的地址方便上传服务器
        print("onStop  " + data.path);
        if (widget.stopRecord != null) {
          widget.stopRecord(data.path, data.audioTimeLength);
        }
      } else if (data.msg == "onStart") {
        print("onStart --");
        if (widget.startRecord != null) {
          widget.startRecord();
        }
      }
    });

    ///录制过程监听录制的声音的大小 方便做语音动画显示图片的样式
    recordPlugin.responseFromAmplitude.listen((data) {
      var voiceData = double.parse(data.msg);
      setState(() {
        if (voiceData > 0 && voiceData < 0.1) {
          voiceIco = ImageHelper.wrapAssets("voicelib_ic_volume_1");
        } else if (voiceData > 0.2 && voiceData < 0.3) {
          voiceIco = ImageHelper.wrapAssets("voicelib_ic_volume_2");
        } else if (voiceData > 0.3 && voiceData < 0.4) {
          voiceIco = ImageHelper.wrapAssets("voicelib_ic_volume_3");
        } else if (voiceData > 0.4 && voiceData < 0.5) {
          voiceIco = ImageHelper.wrapAssets("voicelib_ic_volume_4");
        } else if (voiceData > 0.5 && voiceData < 0.6) {
          voiceIco = ImageHelper.wrapAssets("voicelib_ic_volume_5");
        } else if (voiceData > 0.6 && voiceData < 0.7) {
          voiceIco = ImageHelper.wrapAssets("voicelib_ic_volume_6");
        } else if (voiceData > 0.7 && voiceData < 0.8) {
          voiceIco = ImageHelper.wrapAssets("voicelib_ic_volume_7");
        } else if (voiceData > 0.8 && voiceData < 1) {
          voiceIco = ImageHelper.wrapAssets("voicelib_ic_volume_8");
        } else {
          voiceIco = ImageHelper.wrapAssets("voicelib_ic_volume_1");
        }
        if (overlayEntry != null) {
          overlayEntry.markNeedsBuild();
        }
      });

      print("振幅大小   " + voiceData.toString() + "  " + voiceIco);
    });
  }

  ///录音时间过短提示
  tooShort() {
    LogUtil.e("录音时间过短提示");
    setState(() {
      isUp = true;
      isTooShort = true;
      textShow = S.current.voice_recoder_normal;
      toastShow = S.current.voice_dialog_time_short;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onLongPressStart: (details) {
          starty = details.globalPosition.dy;
          showVoiceView();
        },
        onLongPressEnd: (details) {
          debugPrint("onLongPressEnd--------");
          if (60 - curentTimer < 1) {
            tooShort();
          } else {
            hideVoiceView();
          }
        },
        onLongPressMoveUpdate: (details) {
          offset = details.globalPosition.dy;
          moveVoiceView();
        },
        onTapUp: (details) {
          debugPrint("onTapUp--------");
        },
        child: Container(
          height: 60,
          color: Colors.blue,
          margin: EdgeInsets.fromLTRB(50, 0, 50, 20),
          child: Center(
            child: Text(
              textShow,
            ),
          ),
        ),
      ),
    );
  }

  ///初始化语音录制的方法
  void _init() async {
    recordPlugin.init();
  }

  ///开始语音录制的方法
  void start() async {
    recordPlugin.start();
    showTime();
  }

  ///停止语音录制的方法
  void stop() {
    recordPlugin.stop();
  }

  ///显示录音悬浮布局
  buildOverLayView(BuildContext context) {
    if (overlayEntry == null) {
      overlayEntry = new OverlayEntry(builder: (content) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.5 - 80,
          left: MediaQuery.of(context).size.width * 0.5 - 80,
          child: Material(
            type: MaterialType.transparency,
            child: Center(
              child: Opacity(
                opacity: 1.0,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Color(0xff545454),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 100,
                        height: 100,
                        alignment: Alignment.center,
                        child: Stack(
                          children: <Widget>[
                            Visibility(
                              visible: isUp,
                              child: Image.asset(
                                isTooShort?timeShortIco: cancleIco,
                                width: 80,
                                height: 80,
                              ),
                            ),
                            Visibility(
                              visible: !isUp,
                              child: curentTimer > 10
                                  ? Image.asset(
                                      voiceIco,
                                      width: 100,
                                      height: 100,
                                    )
                                  : Text(
                                      "$curentTimer",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 76,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Container(
//                      padding: EdgeInsets.only(right: 20, left: 20, top: 0),
                        child: Text(
                          toastShow,
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Color(0xffA6A6A6),
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
      Overlay.of(context).insert(overlayEntry);
    }
  }

  ///显示录音悬浮框
  showVoiceView() {
    setState(() {
      isUp = false;
      isTooShort = false;
      textShow = S.current.voice_recorder_recording;
      voiceState = false;
      curentTimer = 60;
    });
    buildOverLayView(context);
    start();
  }

  showTime() {
    ///间隔1秒
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      ///自减
      LogUtil.e("curentTimer===$curentTimer");
      curentTimer--;
      LogUtil.e("curentTimer222===$curentTimer");

      ///到10秒后显示即将发送倒计时,倒计时结束时停止录音
      if (curentTimer == 0) {
        _timer.cancel();
        _timer = null;
        stop();
        if (overlayEntry != null) {
          overlayEntry.remove();
          overlayEntry = null;
        }
      } else {
        if (isTooShort) {
          // 延时1s关闭弹框
          Future.delayed(Duration(microseconds: 600), () {
            hideVoiceView();
            print('延时600毫秒执行');
          });
        }
        else {
          if (curentTimer < 11 && !isUp) {
            toastShow = S.current.voice_dialog_time_send;
          }
        }
      }
    });
  }

  ///隐藏录音悬浮框
  hideVoiceView() {
    setState(() {
      textShow = S.current.voice_recoder_normal;
      voiceState = true;
    });
    stop();
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }

    if (isUp) {
      print("取消发送");
    } else {
      print("进行发送");
    }
  }

  ///手指移动时，悬浮框改变显示内容
  moveVoiceView() {
    // print(offset - start);
    setState(() {
      isUp = starty - offset > 100 ? true : false;
      if (isUp) {
        textShow = S.current.voice_recorder_want_cancel;
        toastShow = textShow;
      } else {
        textShow = S.current.voice_recorder_recording;
        toastShow = curentTimer > 10
            ? S.current.voice_dialog_want_cancel
            : S.current.voice_dialog_time_send;
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    super.dispose();
  }
}
