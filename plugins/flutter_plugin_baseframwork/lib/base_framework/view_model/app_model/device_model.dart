import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_plugin_baseframwork/base_framework/config/frame_constant.dart';
/*
 *获取设备信息
 *@author zln
 *create at 2020/10/27 下午5:30
 */
class DeviceModel extends ChangeNotifier{
  bool isAndroid = false;
  bool isIOS = false;
  AndroidDeviceInfo androidDeviceInfo;
  IosDeviceInfo iosDeviceInfo;

  DeviceModel({this.isAndroid,this.isIOS,this.androidDeviceInfo,this.iosDeviceInfo}){
    assembleDeviceInfo();
  }

  assembleDeviceInfo() async{
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if(Platform.isAndroid){
      await deviceInfoPlugin.androidInfo.then((value) {
          isAndroid = true;
          androidDeviceInfo = value;
          SpUtil.putString(BaseFrameConstants.DEVICE_UUID, value.androidId);
      });
    }
    else if(Platform.isIOS){
      await deviceInfoPlugin.iosInfo.then((value) {
        isIOS = true;
        iosDeviceInfo = value;
        SpUtil.putString(BaseFrameConstants.DEVICE_UUID, value.identifierForVendor);
      });
    }
  }
  
}