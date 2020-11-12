import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hbys/generated/l10n.dart';
import 'package:flutter_hbys/widgets/my_colors.dart';
import 'package:flutter_plugin_baseframwork/base_framework/utils/image_helper.dart';
import '../xf_speech_plugin.dart';


///语音转文字（科大讯飞）
class SpeechToText extends StatefulWidget {

  Function onSend;
  SpeechToText({this.onSend});

  @override
  _SpeechToTextState createState() => _SpeechToTextState();
}

class _SpeechToTextState extends State<SpeechToText> {

  OverlayEntry overlayEntry;
  int pageStatus = 0;//0代表初始状态，1代表按下录音键开始说话，2代表松开录音键结束录音
  String translateResult = S.current.speech_hint_text;
  String iflyResultString='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
    translateResult = S.current.speech_hint_text;
  }

  Future<void> initPlatformState() async {
    final voice = XfSpeechPlugin.instance;
    voice.initWithAppId(iosAppID: '5d4281f8', androidAppID: '5fab3f2f');
    final param = new XFVoiceParam();
    param.domain = 'iat';
    param.asr_ptt = '0';
    param.asr_audio_path = 'xme.pcm';
    param.result_type = 'plain';
    param.voice_name = 'vixx';

    voice.setParameter(param.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: pageStatus == 1 ?MyColors.color_2B2B2B_30:Colors.transparent,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: buildOverLayView(context),
      ),
    )
      ;
  }

  Widget buildOverLayView(BuildContext context){

    // if(overlayEntry == null){
    //   overlayEntry = OverlayEntry(builder: (content){
        return Stack(
          children: <Widget>[
            Positioned(
                top: MediaQuery.of(context).size.height - 265 ,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      //标题
                      Visibility(
                        visible: pageStatus == 0,
                        child:Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            "${S.current.speech_title}",
                            style: TextStyle(
                                color: MyColors.color_333333,
                                fontSize: 14
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                        ,
                      ),
                      //语音转文字的结果显示
                      Visibility(
                          visible: pageStatus !=0,
                          child:Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 20,left: 30,right: 30),
                            child: Text(
                              "$translateResult",
                              style: TextStyle(
                                  color:translateResult == S.current.speech_hint_text?MyColors.color_B2B2B2: MyColors.color_333333,
                                  fontSize: 14
                              ),
                            ),
                          )
                      ),
                      Positioned(
                        bottom: 41,
                        left: 0,
                        right: 0,
                        child: Container(
                          margin: EdgeInsets.only(top: 100,bottom: 0,left: 30,right: 30),
                          child:  Column(
                            children: <Widget>[
                              Visibility(
                                visible: pageStatus == 0,
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: Text(
                                  '${S.current.speech_tip}',
                                  style: TextStyle(
                                      color: MyColors.color_B2B2B2,
                                      fontSize: 12
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[

                                  Visibility(
                                    visible: pageStatus !=1,
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child:
                                    pageStatus == 2?
                                    GestureDetector(
                                      onTap: (){
                                        //todo 清空语音转文字的内容
                                        onClearContent();
                                      },
                                      child:  Text(
                                        '${S.current.speech_clear}',
                                        style: TextStyle(
                                            color: MyColors.color_333333,
                                            fontSize: 16
                                        ),
                                      ),
                                    ):GestureDetector(
                                      onTap: (){
                                        //todo 关闭弹框
                                        onClosePage(context);
                                      },
                                      child: Image.asset(
                                        ImageHelper.wrapAssets("img_voiceinput_close"),
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                    ,
                                  ),

                                  new Container(
                                      width: 50,
                                      height: 50,
                                      alignment: Alignment.center,
                                      child: InkWell(
                                          onTap:(){
                                            setState(() {
                                              if(translateResult == S.current.speech_hint_text){
                                                pageStatus = 0;
                                              }
                                              else {
                                                pageStatus = 2;
                                              }
                                            });

                                            onTapUp();
                                          },
                                          onTapDown:(content){
                                            //todo 按下按钮
                                            setState(() {
                                              pageStatus = 1;
                                            });
                                            onTapDown();
                                          },
                                          onTapCancel: (){
                                            setState(() {
                                              pageStatus = 0;
                                            });
                                            onTapUp();
                                          },

                                          child: Image.asset(ImageHelper.wrapAssets(pageStatus !=1?'img_voiceinput_default':'img_voiceinput_select'),fit: BoxFit.fill)
                                      )
                                  ),
                                  Visibility(
                                    visible: pageStatus ==2,
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child:
                                    GestureDetector(
                                      onTap: (){
                                        //todo 发送转换后的文字消息
                                        onClearContent();
                                        if(widget.onSend != null){
                                          widget.onSend(translateResult);
                                        }
                                      },
                                      child: Text(
                                        '${S.current.speech_send}',
                                        style: TextStyle(
                                            color: MyColors.color_10B9A4,
                                            fontSize: 16
                                        ),
                                      ),
                                    )

                                    ,
                                  )
                                ],
                              )

                            ],
                          ),
                        ),
                      ),



                    ],
                  ),
                )
            )
          ],
        )
        ;
    //   });
    //   Overlay.of(context).insert(overlayEntry);
    //
    // }
  }

  ///按下录音按钮
  onTapDown() {
    print("tap down");
    final listen = XfSpeechListener(
        onVolumeChanged: (volume) {
          print('$volume');
        },
        onResults: (String result, isLast) {
          debugPrint('result===$result;isLast=$isLast');
          if (result.length > 0 && !isLast) {
            setState(() {
              iflyResultString += result;
              debugPrint('iflyResultString===$iflyResultString');
              setState(() {
                if(!TextUtil.isEmpty(iflyResultString) ){
                  translateResult = iflyResultString;
                }
              });
            });
          }
        },
        onCompleted: (Map<dynamic, dynamic> errInfo, String filePath) {
          setState(() {

          });
        }
    );
    XfSpeechPlugin.instance.startListening(listener: listen);
  }

  ///抬起录音按钮
  onTapUp() {
    print("tap up");
      XfSpeechPlugin.instance.stopListening();
  }
  ///清空
  onClearContent(){
    setState(() {
      pageStatus = 0;
      translateResult = S.current.speech_hint_text;
      iflyResultString = '';
    });
  }
  ///关闭弹框
  onClosePage(BuildContext context){
    Navigator.of(context).pop();
  }
}
