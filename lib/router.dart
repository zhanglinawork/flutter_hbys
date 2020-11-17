import 'package:flutter/material.dart';
import 'package:flutter_hbys/rong_im/pages/conversation_page.dart';
import 'package:flutter_hbys/rong_im/pages/file_preview_page.dart';
import 'package:flutter_hbys/rong_im/pages/image_preview_page.dart';
import 'package:flutter_hbys/rong_im/pages/sight/video_play_page.dart';
import 'package:flutter_hbys/rong_im/pages/sight/video_record_page.dart';
import 'package:flutter_hbys/rong_im/pages/webview_page.dart';

final routes = {
  '/conversation': (context, {arguments}) =>
      ConversationPage(arguments: arguments),
  '/image_preview': (context, {arguments}) =>
      ImagePreviewPage(message: arguments),
  '/video_record': (context, {arguments}) =>
      VideoRecordPage(arguments: arguments),
  '/video_play': (context, {arguments}) => VideoPlayPage(message: arguments),
  '/file_preview': (context, {arguments}) =>
      FilePreviewPage(message: arguments),
  '/webview': (context, {arguments}) => WebViewPage(arguments: arguments),
};
/// 统一处理
// ignore: missing_return, top_level_function_literal_block
var onGenerateRoute = (RouteSettings settings) {
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
