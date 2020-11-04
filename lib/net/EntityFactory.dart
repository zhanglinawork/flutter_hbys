
import 'package:flutter_hbys/generated/json/base/json_convert_content.dart';
/// 实体转换工厂类
class EntityFactory{
  static T generateOBJ<T>(jsondata){
    if(jsondata == null){
      return null;
    }
    else{
      //将网络请求返回的json转换成对应的实体类
      return JsonConvert.fromJsonAsT<T>(jsondata);
    }
  }
}
