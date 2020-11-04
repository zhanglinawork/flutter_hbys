
import 'dart:isolate';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_plugin_baseframwork/base_framework/observe/net_observer.dart';
import 'package:flutter_plugin_baseframwork/base_framework/view_model/app_model/app_status_model.dart';
import 'package:oktoast/oktoast.dart';
/*
 *app 状态检测类，负责各种状态的检测，如网络状态
 *@author zln
 *create at 2020/10/27 下午3:06
 */
class AppIsolates{
  final AppStatusModel appStatusModel = AppStatusModel();
  static AppIsolates _appIsolates;
  static AppIsolates getInstance(){
    if(_appIsolates == null)
      {
        _appIsolates = AppIsolates._();
      }
    return _appIsolates;
  }
  AppIsolates._();

  Isolate _netIsolate;
  final ReceivePort _netReceivePort = ReceivePort();
  SendPort _netSendPort;
  void initNetObserver() async{
    if(_netIsolate != null)
      return;
    _netIsolate = await Isolate.spawn(observerNetState(_netReceivePort.sendPort), _netReceivePort.sendPort);
    _netReceivePort.listen((message) {
      debugPrint('$message');
      String key = message[0];
      var value =message[1];
      if(key == kNetPortKey){
        _netSendPort = value;
      }else if(key == kNetAvailable){
        //网络是可用的
        debugPrint('${message[1]}');
        String available = message[1];
        if(available == kNetDisable){
          showToast("网络不可用");
          appStatusModel.setNetStatus(NetStatus.Disable);
          //TODO 网络不可用时的处理

        }
        else if(available == kNetEnable){
           debugPrint('网络正常');
           appStatusModel.setNetStatus(NetStatus.Enable);
        }
      }
    });

    /*
     *监听网络连接方式
     *@author zln
     *create at 2020/10/27 下午4:06
     */
    Connectivity().onConnectivityChanged.listen((netType) {
      debugPrint('$netType');
      if(netType == ConnectivityResult.wifi){
        appStatusModel.setNetType(NetType.wifi);
      }
      else if(netType == ConnectivityResult.mobile){
        appStatusModel.setNetType(NetType.mobile);
      }
      else if(netType == ConnectivityResult.none){
        appStatusModel.setNetType(NetType.none);
      }
    });
  }
}