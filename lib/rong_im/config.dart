import 'package:flutter_hbys/constants_config/url_config.dart';

///融云相关配置信息

  String RONG_APPKEY_TEST = "cpj2xarlc14tn";
  String RONG_APPKEY_RELEASE = "pgyu6atqp9f5u";
  String RongAppKey = UrlConfig.isProduct?RONG_APPKEY_RELEASE:RONG_APPKEY_TEST;
