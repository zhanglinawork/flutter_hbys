import 'dart:io';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SharePreferenceUtil.dart';

///日志拦截器
class DioLogInterceptor extends Interceptor {
  String TAG = "requestLog===========";
  @override
  Future onRequest(RequestOptions options) async {
    String requestStr = "\n==================== Request ====================\n"
        "- URL:\n${options.baseUrl + options.path}\n"
        "- METHOD: ${options.method}\n";
    /*----添加公用头部参数start-----*/
    options = await addHeaders(options).then((value) => value);
    /*----添加公用头部参数end-----*/
    requestStr += "- HEADER:\n${options.headers.mapToStructureString()}\n";

    final data = options.data;
    if (data != null) {
      if (data is Map)
        requestStr += "- BODY:\n${data.mapToStructureString()}\n";
      else if (data is FormData) {
        final formDataMap = Map()
          ..addEntries(data.fields)
          ..addEntries(data.files);
        requestStr += "- BODY:\n${formDataMap.mapToStructureString()}\n";
      } else
        requestStr += "- BODY:\n${data.toString()}\n";
    }
    LogUtil.e(requestStr);
    return options;
  }

  /*
   *添加公共请求头
   *@author zln
   *create at 2020/11/2 下午2:28
   */
  Future<RequestOptions> addHeaders(RequestOptions options) async{
    options.headers['clienttype'] =  await  Platform.isAndroid ? "ANDROID" : (Platform.isIOS ? "IOS" : "未知");
    await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String version = packageInfo.version;
      options.headers['clientversion'] = version;
    });
    await SharedPreferences.getInstance().then((value) {
      options.headers['jaccessToken'] = value.get(ShareUtils.TOKEN)== null?
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1OTkzODUxNzIsInVzZXJuYW1lIjoiMTg5MTAzNDY5MjYifQ.hMo1j9iEDYp_xtTOhJ0kj-80_NYsiDxDuMPrdTKE2rM':
      value.get(ShareUtils.TOKEN);
    });
    return options;
  }

  @override
  Future onError(DioError err) async {
    String errorStr = "\n==================== Response ====================\n"
        "- URL:\n${err.request.baseUrl + err.request.path}\n"
        "- METHOD: ${err.request.method}\n";

    errorStr +=
        "- HEADER:\n${err.response.headers.map.mapToStructureString()}\n";
    if (err.response != null && err.response.data != null) {
      LogUtil.e('╔ ${err.type.toString()}');
      errorStr += "- ERROR:\n${_parseResponse(err.response)}\n";
    } else {
      errorStr += "- ERRORTYPE: ${err.type}\n";
      errorStr += "- MSG: ${err.message}\n";
    }
    LogUtil.e(errorStr);
    return err;
  }

  @override
  Future onResponse(Response response) async {
    String responseStr = "\n==================== Response====================\n"
        "- URL:\n${response.request.uri}\n";
    responseStr += "- HEADER:\n{";
    response.headers.forEach(
        (key, list) => responseStr += "\n  " + "\"$key\" : \"$list\",");
    responseStr += "\n}\n";
    responseStr += "- STATUS: ${response.statusCode}\n";

    if (response.data != null) {
      responseStr += "- BODY:\n ${_parseResponse(response)}";
    }
    printWrapped(responseStr);
    return response;
  }

  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk

    pattern.allMatches(text).forEach((match) => LogUtil.e(match.group(0)));
  }

  String _parseResponse(Response response) {
    String responseStr = "";
    var data = response.data;
    if (data is Map)
      responseStr += data.mapToStructureString();
    else if (data is List)
      responseStr += data.listToStructureString();
    else
      responseStr += response.data.toString();

    return responseStr;
  }
}

extension Map2StringEx on Map {
  String mapToStructureString({int indentation = 2}) {
    String result = "";
    String indentationStr = " " * indentation;
    if (true) {
      result += "{";
      this.forEach((key, value) {
        if (value is Map) {
          var temp = value.mapToStructureString(indentation: indentation + 2);
          result += "\n$indentationStr" + "\"$key\" : $temp,";
        } else if (value is List) {
          result += "\n$indentationStr" +
              "\"$key\" : ${value.listToStructureString(indentation: indentation + 2)},";
        } else {
          result += "\n$indentationStr" + "\"$key\" : \"$value\",";
        }
      });
      result = result.substring(0, result.length - 1);
      result += indentation == 2 ? "\n}" : "\n${" " * (indentation - 1)}}";
    }

    return result;
  }
}

extension List2StringEx on List {
  String listToStructureString({int indentation = 2}) {
    String result = "";
    String indentationStr = " " * indentation;
    if (true) {
      result += "$indentationStr[";
      this.forEach((value) {
        if (value is Map) {
          var temp = value.mapToStructureString(indentation: indentation + 2);
          result += "\n$indentationStr" + "\"$temp\",";
        } else if (value is List) {
          result += value.listToStructureString(indentation: indentation + 2);
        } else {
          result += "\n$indentationStr" + "\"$value\",";
        }
      });
      result = result.substring(0, result.length - 1);
      result += "\n$indentationStr]";
    }

    return result;
  }
}
