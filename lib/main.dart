import 'package:fbutton/fbutton.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_hbys/app_config.dart';
import 'package:flutter_hbys/rong_im/config.dart';
import 'package:flutter_hbys/test/testPage.dart';
import 'package:flutter_plugin_baseframwork/base_framework/config/global_provider_manager.dart';
import 'package:flutter_plugin_baseframwork/base_framework/view_model/app_model/locale_model.dart';
import 'package:flutter_plugin_baseframwork/flutter_plugin_baseframwork.dart';
import 'package:flutter_plugin_record/index.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';

void main() async{
  await AppConfig.init();

  runApp(MyApp());
  //状态栏置透明
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterPluginBaseframwork.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {

    ///设计图尺寸
    setDesignWHD(750, 1334,density: 1.0);

    return OKToast(
      child: MultiProvider(
        providers: providers,
        child: Consumer<LocaleModel>(
            builder: (ctx,localModel,child){
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                //home: testPage().generateWidget(),
                home: new MyHomePage(title: 'Flutter Demo Home Page'),
                routes: {
                  // "RecordScreen": (BuildContext context) => new RecordScreen(),
                  // "RecordMp3Screen": (BuildContext context) => new RecordMp3Screen(),
                  "WeChatRecordScreen": (BuildContext context) => VoiceWidget(),
                  // "PathProviderScreen": (BuildContext context) => new PathProviderScreen(),
                },
              );
            }),),
    );

  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("flutter版微信语音录制实现"),
      ),
      body: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // new FlatButton(
            //     onPressed: () {
            //       Navigator.pushNamed<dynamic>(context, "RecordScreen");
            //     },
            //     child: new Text("进入语音录制界面")),
            // new FlatButton(
            //     onPressed: () {
            //       Navigator.pushNamed<dynamic>(context, "RecordMp3Screen");
            //     },
            //     child: new Text("进入录制mp3模式")),
            FButton(padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
              text: "进入仿微信录制界面",
              style: TextStyle(color: Colors.green),
              color: Colors.white,
              corner: FCorner.all(6.0),
              strokeWidth: 1,
              strokeColor: Colors.green,
              onPressed: (){
                //todo 点击按钮
                Navigator.pushNamed<dynamic>(context, "WeChatRecordScreen");
              },
            )
            // new FlatButton(
            //     onPressed: () {
            //       Navigator.pushNamed<dynamic>(context, "PathProviderScreen");
            //     },
            //     child: new Text("进入文件路径获取界面")),
          ],
        ),
      ),
    );
  }
}