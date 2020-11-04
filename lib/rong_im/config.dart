import 'package:flutter_hbys/constants_config/url_config.dart';

///融云相关配置信息
class RongConfig{
  static final RONG_APPKEY_TEST = "cpj2xarlc14tn";
  static final RONG_APPKEY_RELEASE = "pgyu6atqp9f5u";
  static String RongAppKey = UrlConfig.isProduct?RONG_APPKEY_RELEASE:RONG_APPKEY_TEST;
}