
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_plugin_baseframwork/base_framework/utils/image_helper.dart';

/// 自定义淘宝二楼效果头部组件
class DefineHeaderWidget extends StatefulWidget {
  final LinkHeaderNotifier linkNotifier;

  const DefineHeaderWidget({
    Key key,
    this.linkNotifier,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DefineHeaderWidgetState();
  }
}

class DefineHeaderWidgetState extends State<DefineHeaderWidget> {
  RefreshMode get _refreshState => widget.linkNotifier.refreshState;
  double get _pulledExtent => widget.linkNotifier.pulledExtent;
  bool get _noMore => widget.linkNotifier.noMore;
  String tishiTxt = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    debugPrint("DefineHeader-------dispose()-------");
    super.dispose();
  }

  // 旋转太阳
  void changeTxt(String msg) {
    setState(() {
      tishiTxt = msg;
    });
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e('当前状态_refreshState=${_refreshState}，_pulledExtent=${_pulledExtent}');
    if (_noMore) return Container();
    if(_refreshState == RefreshMode.inactive){
      changeTxt("下拉可以刷新");
    }
    else if(_refreshState == RefreshMode.drag ){
      if(_pulledExtent <= 60 ){
        changeTxt("下拉可以刷新");
      }
      else if(_pulledExtent > 60 && _pulledExtent<120){
        changeTxt("释放立即刷新");
      }
      else {
        changeTxt("松手有惊喜");
      }

    }
    else if (
    _refreshState == RefreshMode.armed||
        _refreshState == RefreshMode.refresh) {
      changeTxt("正在刷新");
    } else if (_refreshState == RefreshMode.done ||
        _refreshState == RefreshMode.inactive) {
      changeTxt("刷新完成");
    }
    return Stack(
      children: <Widget>[
        // 背景
        Container(
          width: double.infinity,
          height: 70,
          color: Colors.transparent,
        ),
        Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageHelper.HeaderloadingWidget(),
                Text('${tishiTxt}')
              ],
            )
        )
      ],
    );
  }
}