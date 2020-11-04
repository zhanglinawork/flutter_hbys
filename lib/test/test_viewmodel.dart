import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter_hbys/net/DioManager.dart';
import 'package:flutter_hbys/net/NWMethod.dart';
import 'package:flutter_hbys/constants_config/url_config.dart';
import 'package:flutter_hbys/test/test_more_entity.dart';
import 'package:flutter_plugin_baseframwork/base_framework/view_model/refresh_list_view_state_model.dart';
import 'product_item_entity.dart';
import 'product_list_entity.dart';
import '../constants_config/reqestApi.dart';

///测试的viewmodel
class TestViewModel extends RefreshListViewStateModel<ProductItemEntity> {
  @override
  Future<List<ProductItemEntity>> loadData({int pageNum}) {
    // TODO: implement loadData
    Future<List<ProductItemEntity>> result = reqFirstData(pageNum: pageNum);
    // debugPrint("loadData--result=$result");
    return result;
  }

  @override
  Future<List<ProductItemEntity>> loadMoreData({int pageNum}) {
    // TODO: implement loadMoreData
    return reqMoreData(pageNum: pageNum);
  }

  /*
   *下拉刷新
   *@author zln
   *create at 2020/10/30 下午6:33
   */
  Future<List<ProductItemEntity>> reqFirstData({int pageNum}) async {
    // TODO: implement loadData
    List<ProductItemEntity> datas;
    Map<String, dynamic> parm = new HashMap();
    parm["orderNumber"] = "";
    parm["cardNumber"] = "";
    parm["productTypeId"] = "12";
    debugPrint("parm==${parm}");

    ProductListData resultData = await DioManager(mBaseUrl: UrlConfig.HOST_JAVA_NEW).request<ProductListData>(
        RequestApi.getlistFrom2020716[0],
        RequestApi.getlistFrom2020716[1],
        "getProductPackages",
        params: parm);

    if (resultData == null) {
      datas = null;
    } else {
      datas = resultData.firstPageItems;
    }
    debugPrint("reqFirstData--datas=$datas");
    return datas;
  }

  /*
   *请求加载更多
   *@author zln
   *create at 2020/10/30 下午5:41
   */
  Future<List<ProductItemEntity>> reqMoreData({int pageNum}) async {
    // TODO: implement loadData
    List<ProductItemEntity> moreDatas;
    Map<String, dynamic> parm = new HashMap();
    parm["pageNo"] = pageNum;
    parm["pageSize"] = pageSize;
    parm["productTypeId"] = "12";
    debugPrint("parm==${parm}");

    TestMoreEntity resultData = await DioManager(mBaseUrl: UrlConfig.HOST_JAVA_NEW)
        .request<TestMoreEntity>(RequestApi.getProductByPage[0],
            RequestApi.getProductByPage[1], "getProductByPage",
            params: parm);
    if (resultData == null) {
      moreDatas = null;
    } else {
      moreDatas = resultData.records;
    }
    return moreDatas;
  }

  @override
  void setEmpty() {
    // TODO: implement setEmpty
    super.setEmpty();
  }

  @override
  void setEmptyError() {
    // TODO: implement setEmptyError
    super.setEmptyError();
  }
}
