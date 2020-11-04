import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/cupertino.dart';

const String kNetPortKey = 'kNetPortKey';
const String kNetAvailable = 'kNetAvailable';
const String kNetEnable = 'kEnable', kNetDisable = 'kDisable';
observerNetState(SendPort sendPort) {
  final String china = 'baidu.com';
  final String usa = 'google.com';
  final ReceivePort receivePort = ReceivePort();
  receivePort.listen((message) {
    debugPrint('$kNetPortKey : $message');
  });

  sendPort.send([kNetPortKey, receivePort.sendPort]);
  /*
   *每10s检测一下网络连接状态
   *@author zln
   *create at 2020/10/27 下午3:31
   */
  Timer.periodic(Duration(seconds: 10), (timer) async {
    try {
      String host = china;
      final result = await InternetAddress.lookup(host);
      debugPrint('$kNetPortKey $result');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        sendPort.send([kNetAvailable, kNetEnable]);
      } else {
        sendPort.send([kNetAvailable, kNetDisable]);
      }
    } on SocketException catch (_) {
      sendPort.send([kNetAvailable, kNetDisable]);
    }
  });
}
