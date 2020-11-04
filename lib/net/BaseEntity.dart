
import 'package:flutter/cupertino.dart';

import 'EntityFactory.dart';

class BaseEntity<T>{
  var code;
  var message;
  T data;

  BaseEntity({this.code,this.message,this.data});
  factory BaseEntity.fromJson(jsondata){
    debugPrint("BaseEntity--data=${EntityFactory.generateOBJ<T>(jsondata["data"])}");
    return BaseEntity(
      code: jsondata["state"],
      message: jsondata["message"],
      // data值需要经过工厂转换为我们传进来的类型
      data: EntityFactory.generateOBJ<T>(jsondata["data"]),
    );
  }
}