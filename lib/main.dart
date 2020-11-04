import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_hbys/test/testPage.dart';
import 'package:flutter_plugin_baseframwork/base_framework/config/global_provider_manager.dart';
import 'package:flutter_plugin_baseframwork/base_framework/view_model/app_model/locale_model.dart';
import 'package:flutter_plugin_baseframwork/flutter_plugin_baseframwork.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

void main() {
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
                home: testPage().generateWidget(),
              );
            }),),
    );

  }
}
