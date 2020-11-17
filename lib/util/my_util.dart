import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';

class MyUtil{

  ///获取要加载的图片的url的集合
   static List<String> getattachPaths(String attachPath) {
    LogUtil.e("getattachPaths--要拆分的图片路径attachPath==" + attachPath);
    if (TextUtil.isEmpty(attachPath)) {
      return new List();
    }

    List<String> picurls = new List();
    List<String> strs = null;
    if (attachPath.contains(",")) {
      strs = attachPath.split(",");
    } else if (attachPath.contains("*")) {
      strs = attachPath.split("*");
    }
    LogUtil.e("getattachPaths--要拆分的图片路径strs==" +strs.asMap().toString());
    if (strs != null) {
      for (int i = 0; i < strs.length; i++) {
        if (strs[i].contains("|")) {
          List<String> picurl = strs[i].split("|");
          picurls.add(picurl[1].replaceAll("\\", ""));
        } else {
          picurls.add(strs[i].replaceAll("\\", ""));
        }
      }
    } else {
      if (attachPath.contains("|")) {
        List<String>  picurl = attachPath.split("\\|");
        picurls.add(picurl[1].replaceAll("\\", ""));
      } else {
        picurls.add(attachPath.replaceAll("\\", ""));
      }
    }
    LogUtil.e("getattachPaths--拆分后的图片路径picurls==" + picurls.asMap().toString());
    return picurls;
  }
}