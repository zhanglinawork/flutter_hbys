import 'package:common_utils/common_utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hbys/constants_config/url_config.dart';
import 'package:oktoast/oktoast.dart';
import 'BaseEntity.dart';
import 'DioLogInterceptor.dart';
import 'ErrorEntity.dart';
import 'NWMethod.dart';
///网络请求管理类
class DioManager{

  Dio dio;
  List<String> reqTags ;//存放每次发送的请求，避免重复发送同一个请求
  static final DioManager _dioManager = DioManager._internal();

  factory DioManager({String mBaseUrl}){
    DioManager _mdioManager = _dioManager;
    if(mBaseUrl != null){
      _mdioManager.dio.options.baseUrl = mBaseUrl;
    }
     return _mdioManager;
  }

  DioManager._internal()  {
    LogUtil.e('DioManager._internal---reqTags=${reqTags}');
    if(reqTags == null){
      reqTags = List();
    }
    LogUtil.e('DioManager._internal---reqTags22=${reqTags}，dio=${dio}');
    if(dio == null){
      BaseOptions options = BaseOptions(
        baseUrl: UrlConfig.HOST_JAVA_NEW,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        receiveDataWhenStatusError: false,
        connectTimeout: 3000,
        receiveTimeout: 3000,
      );
      dio = Dio(options);
      dio.interceptors.add(new DioLogInterceptor());
      LogUtil.e('DioManager._internal--dio222=${dio}');
    }

  }

  Future<T> request<T>(NWMethod method,String path,String reqTag,{String baseurl,Map params, Function(T) success,Function(ErrorEntity) error }){
    if(checkIsReqAdded(reqTag)){
      return null;
    }
    else{
      //将请求加入到请求tag中
      addRegTag(reqTag);
      if(baseurl != null && baseurl.isNotEmpty) {
        dio.options.baseUrl = baseurl;
      }
     return requestNet<T>(method,path,reqTag,params:params,success: success,error: error) ;
    }
  }
  /// 发起网络请求
  Future<T> requestNet<T>(NWMethod method,String path,String reqTag,{Map params, Function(T) success,Function(ErrorEntity) error })
  async {
    BaseEntity entity;
    ErrorEntity errorEntity;
    Response response;
    try {
      if(method == NWMethod.GET ){
        response = await dio.get(path,queryParameters: params);
      }else if(method == NWMethod.POST){
        response = await dio.post(path, data: params);
      }
      else if(method == NWMethod.PUT){
        response = await dio.put(path,queryParameters: params);
      }
      else if(method == NWMethod.DELETE){
        response = await dio.delete(path,queryParameters: params);
      }

      clearReqTag(reqTag);
      if (response != null) {
        debugPrint("response.data=${response.data}");
        entity = BaseEntity<T>.fromJson(response.data);
        if (entity.code.toString() == "200" ) {
          debugPrint("entity.data=${entity.data}");
          if(success != null) {
            success(entity.data);
          }
        }
        else {
          //对返回对错误码进行统一处理
          debugPrint("entity.code=${entity.code}");
          errorEntity = ErrorEntity(code: entity.code, message: entity.message);
          if(error != null)
          error(errorEntity);
        }
      }
      else {
        debugPrint("未知错误-----");
        errorEntity = ErrorEntity(code: -1, message: '未知错误');
        if(error != null)
        error(errorEntity);
      }

    }on DioError catch(e){
      debugPrint("DioError-----${e.type}");
      errorEntity = createErrorEntity(e);
      clearReqTag(reqTag);
      if(error != null)
      error(errorEntity);
    }
    if(errorEntity != null){
      CheckErrorType(errorEntity);
    }
    debugPrint("requestNet--entity=$entity");
    return  entity ==null?null:entity.data;

  }

  ErrorEntity createErrorEntity(DioError error){
    switch(error.type){
      case DioErrorType.CANCEL:
          return ErrorEntity(code: -1, message: '请求取消');
          break;
      case DioErrorType.CONNECT_TIMEOUT:
          return ErrorEntity(code: -1,message: '连接超时');
          break;
      case DioErrorType.SEND_TIMEOUT:
        return ErrorEntity(code: -1,message: '请求超时');
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
          return ErrorEntity(code: -1,message: '响应超时');
          break;
      case DioErrorType.RESPONSE:
        try {
          int errCode = error.response.statusCode;
          String errMsg = error.response.statusMessage;
          return ErrorEntity(code: '$errCode', message: errMsg);
        }on Exception catch(_){
          return ErrorEntity(code: -1,message: '未知错误');
        }
        break;
      default:
        return ErrorEntity(code: -1,message: error.message);


    }
  }

  /// 检查请求是否正在进行
  bool checkIsReqAdded(String reqtag){
    LogUtil.e("检查请求是否正在进行reqTags.length===${reqTags.length}");
    if(reqtag == null || reqtag.isEmpty)
      return false;
    bool result = false;
    for(int i =0;i<reqTags.length;i++){
      LogUtil.e("检查请求是否正在进行reqtag===${reqtag};reqTags[i]=${reqTags[i]}");
      if(reqtag == reqTags[i]){
        result = true;
        break;
      }
    }
    LogUtil.e("检查请求是否正在进行result=${result}");
    return result;
  }
  //添加请求tag
  addRegTag(String reqtag){
    if(reqtag != null && reqtag.isNotEmpty){
      LogUtil.e("添加网络请求===${reqtag}");
      reqTags.add(reqtag);
    }
  }
  //清除请求的tag
  clearReqTag(String reqtag){
    LogUtil.e("清除网络请求===${reqtag}");
    for(int i =0;i<reqTags.length;i++){
      LogUtil.e("网络请求reqtag===${reqtag};reqTags[i]=${reqTags[i]}");
      if(reqtag == reqTags[i]){
        reqTags.remove(reqtag);
        break;
      }
    }
  }
  //清除所有请求的tag
  clearAllTags(){
    if(reqTags != null) {
      reqTags.clear();
    }
  }

  CheckErrorType(ErrorEntity entity) async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.none){
      //todo 无网络统一处理
      showToast("请检查网络设置");
    }
    else{
      if(entity.code == "10004"){
        //todo token失效统一处理
        showToast("token失效");
      }
    }

  }
}