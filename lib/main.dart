import 'package:fbutton/fbutton.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hbys/app_config.dart';
import 'package:flutter_hbys/rong_im/config.dart';
import 'package:flutter_hbys/rong_im/pages/conversation_page.dart';
import 'package:flutter_hbys/rong_im/pages/item/message_item_factory.dart';
import 'package:flutter_hbys/rong_im/util/db_manager.dart';
import 'package:flutter_hbys/rong_im/util/event_bus.dart';
import 'package:flutter_hbys/rong_im/util/user_info_datesource.dart';
import 'package:flutter_hbys/widgets/speech_to_text_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_plugin_baseframwork/base_framework/config/global_provider_manager.dart';
import 'package:flutter_plugin_baseframwork/base_framework/view_model/app_model/locale_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
// import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart'as prefix;
// import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import 'generated/l10n.dart';

void main() async{
  await AppConfig.init();

  runApp(MyApp());
  //状态栏置透明
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static BuildContext getContext() {
    return _MyAppState.getContext();
  }

}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  static BuildContext appContext;

  static BuildContext getContext() {
    return appContext;
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   String platformVersion;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     platformVersion = await FlutterPluginBaseframwork.platformVersion;
  //   } on PlatformException {
  //     platformVersion = 'Failed to get platform version.';
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  //
  //   setState(() {
  //     _platformVersion = platformVersion;
  //   });
  // }

  initPlatformState() async {


    //1.初始化 im SDK
   // prefix.RongIMClient.init(RongAppKey);
    //2.连接 im SDK
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = prefs.get("token");
    String token = "Wz7tJ9LR7wb6/5zR9S/iBUOucLWctLVl2unWjHRJEMvj7n0E41nSYUDPEC+S+C5b@trcu.cn.rongnav.com;trcu.cn.rongcfg.com";
    if (token != null && token.length > 0) {
      // int rc = await RongIMClient.connect(token);
      debugPrint("请求融云连接------");
     RongIMClient.connect(token, (int code, String userId) {

        EventBus.instance.commit(EventKeys.UpdateNotificationQuietStatus, {});
        if (code == 31004 || code == 12) {
          debugPrint("融云连接失败");
          // Navigator.of(context).pushAndRemoveUntil(
          //     new MaterialPageRoute(builder: (context) => new LoginPage()),
          //         (route) => route == null);
        } else if (code == 0) {
         debugPrint("融云连接成功");
          // 连接成功后打开数据库
           _initUserInfoCache();
        }
      });
    } else {
      // Navigator.of(context).pushAndRemoveUntil(
      //     new MaterialPageRoute(builder: (context) => new LoginPage()),
      //         (route) => route == null);
      debugPrint("融云连接失败");
    }
  }

  // 初始化用户信息缓存
  void _initUserInfoCache() {
    DbManager.instance.openDb();
    UserInfoCacheListener cacheListener = UserInfoCacheListener();
    cacheListener.getUserInfo = (String userId) {
      return UserInfoDataSource.generateUserInfo(userId);
    };
    cacheListener.getGroupInfo = (String groupId) {
      return UserInfoDataSource.generateGroupInfo(groupId);
    };
    UserInfoDataSource.setCacheListener(cacheListener);
  }

  @override
  Widget build(BuildContext context) {
    appContext = context;
    ///设计图尺寸
    setDesignWHD(750, 1334,density: 1.0);

    return OKToast(
      child: MultiProvider(
        providers: providers,
        child: Consumer<LocaleModel>(
            builder: (ctx,localModel,child){
              return MaterialApp(
                debugShowCheckedModeBanner: false,
               // locale: localModel.locale,
                //国际化工厂代理
                localizationsDelegates: [
                  // Intl 插件（需要安装）
                  S.delegate,
                  //系统控件 国际化
                  GlobalCupertinoLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate//文本方向等
                ],
                // 设置中文为首选项
                supportedLocales: [const Locale('zh', ''), ...S.delegate.supportedLocales],
                //home: testPage().generateWidget(),
                home: new MyHomePage(title: 'Flutter Demo Home Page'),
                routes: {
                  "WeChatRecordScreen": (BuildContext context) => ConversationPage(),
                  // "WeChatRecordScreen": (BuildContext context) => SpeechToText(
                  //   onSend: (result){
                  //     debugPrint('onSend---result=$result');
                  //   },
                  // ),
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

                // AudioTextForKDXF(
                //   controller: _audioTextController,
                //   wsAddr: 'ws[s]://iat-api.xfyun.cn/v2/iat',//连接地址
                //   child: Text(_audioTextController.value??""),//翻译结果
                // );
                // _audioTextController.audioToText(audioFile);
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