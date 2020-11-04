import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_plugin_baseframwork/base_framework/utils/image_helper.dart';
import 'package:flutter_plugin_baseframwork/base_framework/view/page_state.dart';
import 'package:flutter_plugin_baseframwork/base_framework/view_model/app_model/app_cache_model.dart';
import 'package:flutter_plugin_baseframwork/base_framework/wigets/DefineFooter.dart';
import 'package:flutter_plugin_baseframwork/base_framework/wigets/provider_widget.dart';
import 'package:flutter_plugin_baseframwork/base_framework/wigets/refresh_header.dart';
import 'package:provider/provider.dart';

import 'product_item_entity.dart';
import 'test_viewmodel.dart';

///测试的view
class testPage extends PageState {
  TestViewModel testViewModel = TestViewModel();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return switchStatusBar2DarkByList(
      child: Consumer<AppCacheModel>(builder: (context, cacheModel, child) {
        return ProviderWidget<TestViewModel>(
          model: testViewModel,
          onModelReady: (model) {
            model.initData();
          },
          child: childWidget_easyRefresh(),
          builder: (ctx, pageState, child) {
            debugPrint("model.busy=${pageState.busy}");
            testViewModel = pageState;
            if (pageState.busy) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: ImageHelper.FirstloadingWidget(),
                ),
              );
            } else {
              if (pageState.error) {
                mCommonEmptyView.ChangeView(3);
                return Container(
                  child: Center(
                    child: mCommonEmptyView,
                  ),
                );
              } else if (pageState.empty) {
                mCommonEmptyView.ChangeView(0);
                return Container(
                  child: Center(
                    child: mCommonEmptyView,
                  ),
                );
              }

              return childWidget_easyRefresh();
            }
          },
        );
        //return _Scrollview();
      }),
      reLoad: () {
        testViewModel.initData();
      },
    );
  }

  ///包含下拉刷新，上拉加载更多效果的EasyRefresh
  // ignore: non_constant_identifier_names
  Widget childWidget_easyRefresh() {
    Widget childWidget;

    List<ProductItemEntity> resultData = testViewModel.list;
    debugPrint("testViewModel.list=${resultData.length}");

    if (resultData != null && resultData.length > 0) {
      childWidget = EasyRefresh.custom(
        controller: testViewModel.refreshController,
        onRefresh: testViewModel.refresh,
        onLoad: testViewModel.loadMore,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == resultData.length) {
                  return testViewModel.buildProgressMoreIndicator();
                } else {
                  return buildListData(context, resultData[index]);
                }
              },
              childCount: testViewModel.isNoMore
                  ? resultData.length + 1
                  : resultData.length,
            ),
          ),
        ],
        header: RefreshHeader(),
        footer: DefineFooter(linkNotifier: testViewModel.footerNotifier),
        //footer: DefineFooter(linkNotifier: _linkFooterNotifier),
      );
    } else {
      childWidget = Container();
    }

    return childWidget;
  }

  ///构建列表的每一项
  Widget buildListData(BuildContext context, ProductItemEntity itemdata) {
    List<String> imgs = itemdata.listThumb.split('|');
    String imgurl;
    if (imgs.length > 1) {
      imgurl = imgs[1];
    } else {
      imgurl = imgs[0];
    }

    Widget itemWidget;
    if (itemdata != null) {
      itemWidget = Card(
        margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 80,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Image.network(
                imgurl,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '${itemdata.productName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('${itemdata.sellingPoint}'),
                ],
              ),
            )
          ],
        ),
      );
    }
    return itemWidget;
  }
}
