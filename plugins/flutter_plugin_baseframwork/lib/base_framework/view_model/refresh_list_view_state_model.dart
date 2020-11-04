import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'exception_handler.dart';
import 'list_view_state_model.dart';

/// 主要用于有下拉刷新和上拉加载更多功能的listview
abstract class RefreshListViewStateModel<T> extends ListViewStateModel<T> {
  EasyRefreshController _refreshController = new EasyRefreshController();
  EasyRefreshController get refreshController => _refreshController;
  LinkHeaderNotifier _headerNotifier = LinkHeaderNotifier();
  LinkHeaderNotifier get headerNotifier => _headerNotifier;
  LinkFooterNotifier _footerNotifier = LinkFooterNotifier();
  LinkFooterNotifier get footerNotifier => _footerNotifier;

  /// 当前页码
  int _currentPageNum = 1;
  get currentPageNum => pageNumFirst;

  ///每页加载数量
  get pageDataSize => pageSize;
  bool isNoMore = false; //是否没有更多数据
  String loadMoreText = "没有更多数据";
  TextStyle loadMoreTextStyle =
      new TextStyle(color: const Color(0xFF999999), fontSize: 14.0);

  /// 下拉刷新
  Future<List<T>> refresh({bool init = false}) async {
    try {
      _currentPageNum = pageNumFirst;
      list.clear();
      var data = await loadData(pageNum: pageNumFirst);
      debugPrint("RefreshListViewStateModel--data=$data");
      if(data == null){
        debugPrint("RefreshListViewStateModel--setEmptyError()");
        setEmptyError();
      }
      else if (data.isEmpty) {
        debugPrint("RefreshListViewStateModel--setEmpty()");
        setEmpty();
      } else {
        debugPrint("RefreshListViewStateModel--有数据，refreshController==$refreshController");
        onCompleted(data);
        list.addAll(data);
        if (data.length < pageSize) {
          refreshController.finishLoad(success: true, noMore: true);
          isNoMore = true;
        } else {
          //防止上次上拉加载更多失败,需要重置状态
          isNoMore = false;
          refreshController.resetLoadState();
        }
        if (init) {
          debugPrint("首次加载-----");
          firstInit = false;
          //改变页面状态为非加载中
          setBusy(false);
        } else {
          notifyListeners();
        }
        onRefreshCompleted();

        ///第一次加载且已注册缓存功能的，才进行缓存
        if (init && cacheDataFactory != null) {
          cacheRefreshData();
        }
      }
      return data;
    } catch (e, s) {
      ExceptionHandler.getInstance().handleException(this, e, s);
      return null;
    }
  }

  cacheRefreshData() async {
    final mmkv = await MmkvFlutter.getInstance();
    int i = 0;
    for (String str in cacheDataFactory.cacheListData()) {
      await mmkv.setString('${this.runtimeType.toString()}$i', str);
      i += 1;
    }
  }

  /// 上拉加载更多
  Future<List<T>> loadMore() async {
    try {
      var data = await loadMoreData(pageNum: ++_currentPageNum);
      debugPrint("上拉加载更多--data=${data.length},pageSize=$pageSize");
      if (data.isEmpty) {
        _currentPageNum--;
        isNoMore = true;
        refreshController.finishLoad(success: true, noMore: true);
        notifyListeners();
      } else {
        onCompleted(data);
        list.addAll(data);
        if (data.length < pageSize) {
          isNoMore = true;
          refreshController.finishLoad(success: true, noMore: true);
        } else {
          isNoMore = false;
          refreshController.finishLoad();
        }
        notifyListeners();
      }
      return data;
    } catch (e, s) {
      _currentPageNum--;
      refreshController.finishLoad();
      debugPrint('error--->\n' + e.toString());
      debugPrint('statck--->\n' + s.toString());
      return null;
    }
  }

  // 加载数据
  Future<List<T>> loadData({int pageNum});
  //加载更多数据
  Future<List<T>> loadMoreData({int pageNum});
  @override
  void dispose() {
    debugPrint("-------dispose()-------");
    _refreshController.dispose();
    _headerNotifier.dispose();
    _footerNotifier.dispose();
    super.dispose();
  }

  /*
   *没有更多数据时底部显示的wiget
   *@author zln
   *create at 2020/10/30 下午6:31
   */
  Widget buildProgressMoreIndicator() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          loadMoreText,
          style: loadMoreTextStyle,
        ),
      ),
    );
  }
}
