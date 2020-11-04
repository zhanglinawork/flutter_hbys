import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'DefineHeader.dart';

///淘宝二楼效果
class SecondFloorWidget extends StatefulWidget {
  //Header连接通知器
  final LinkHeaderNotifier linkNotifier;
  //二楼开启状态
  final ValueNotifier<bool> secondFloorOpen;

  final double screenHeight;
   // 上下边距 （主要用于 刘海  和  内置导航键）
  final double topPadding  ;
  final double bottomPadding ;
  final Future<void> Function(bool isOpened) ChangeSecondFloorStatus;

   const SecondFloorWidget(this.screenHeight,this.topPadding,this.bottomPadding,this.linkNotifier, this.secondFloorOpen,this.ChangeSecondFloorStatus, {Key key})
      : super(key: key);

  @override
  SecondFloorWidgetState createState() {
    return SecondFloorWidgetState();
  }
}

class SecondFloorWidgetState extends State<SecondFloorWidget> {
  //触摸二楼高度
  final double _openSecondFloorExtent = 120.0;
  //指示器
  double _indicatorValue = 0.0;
  //二楼高度
  double _secondFloor = 0.0;
  //显示展开收起动画
  bool _toggleAnimation = false;
  Duration _toggleAnimationDuration = Duration(milliseconds: 400);
  //二楼是否打开
  bool _isOpen = false;
  bool _isHideBottom = true;//是否隐藏底部加载动画
  double start_y = 0 ;
  double end_y = 0;

  RefreshMode get _refreshState => widget.linkNotifier.refreshState;
  double get _pulledExtent => widget.linkNotifier.pulledExtent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.linkNotifier.addListener(onLinkNotify);
  }

  void onLinkNotify() {
    setState(() {
      //LogUtil.e("onLinkNotify--_refreshState=${_refreshState}");
      if (_refreshState == RefreshMode.armed ||
          _refreshState == RefreshMode.refresh)
      {
        LogUtil.e("onLinkNotify--_refreshState=1111");
        _indicatorValue = null;
        // 判断是否到展开二楼
        if (widget.secondFloorOpen.value && !_toggleAnimation) {
          LogUtil.e("onLinkNotify--_refreshState=888");

          _isOpen = true;
          //LogUtil.e('齐刘海高度22==${widget.topPadding};底部虚拟按键高度22=${widget.bottomPadding}');
          _secondFloor = widget.screenHeight - widget.topPadding-widget.bottomPadding;
          _toggleAnimation = true;
          Future.delayed(_toggleAnimationDuration, () {
            LogUtil.e("mounted--mounted111=${mounted}");
            if (mounted) {
              setState(() {
                _toggleAnimation = false;
              });
            }
          });
          widget.ChangeSecondFloorStatus(_isOpen);
        }
      }
      else if (_refreshState == RefreshMode.refreshed ||
          _refreshState == RefreshMode.done) {
        LogUtil.e("onLinkNotify--_refreshState=222");
        _indicatorValue = 1.0;
      }
      else {
        if (_refreshState == RefreshMode.inactive) {
          LogUtil.e("onLinkNotify--_refreshState=333");
          _indicatorValue = 0.0;
          _toggleAnimation = true;
          Future.delayed(_toggleAnimationDuration, () {
            LogUtil.e("mounted--mounted222=${mounted}");
            if (mounted) {
              setState(() {
                _toggleAnimation = false;
              });
            }
          });
        } else {
          LogUtil.e("onLinkNotify--_refreshState=444");
          double indicatorValue = _pulledExtent / 70.0 * 0.8;
          _indicatorValue = indicatorValue < 0.8 ? indicatorValue : 0.8;
          // 判断是否到达打开二楼高度
          if (_refreshState == RefreshMode.drag) {
            LogUtil.e("onLinkNotify--_pulledExtent=${_pulledExtent};_openSecondFloorExtent=${_openSecondFloorExtent}");
            if (_pulledExtent >= _openSecondFloorExtent) {
              LogUtil.e("onLinkNotify--_refreshState=666");
              setState(() {
                widget.secondFloorOpen.value = true;
              });

            } else {
              LogUtil.e("onLinkNotify--_refreshState=777");
              setState(() {
                widget.secondFloorOpen.value = false;
              });

            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    LogUtil.e('_toggleAnimation==${_toggleAnimation}');
    // LcfarmSize.getInstance().init(context);

    return
      AnimatedContainer(
        height: _isOpen
            ? _secondFloor
            : _refreshState == RefreshMode.inactive ? 0.0 : _pulledExtent,
        color: Colors.transparent,
        duration: _toggleAnimation
            ? _toggleAnimationDuration
            : Duration(milliseconds: 1),
//        duration: _toggleAnimationDuration,
        onEnd: () {
          if(_isOpen){
            _isHideBottom = false;
          }
          else{
            _isHideBottom = true;
            widget.ChangeSecondFloorStatus(_isOpen);
          }

        },
        child: Stack(
          children: <Widget>[
            //二楼背景图
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                height: widget.screenHeight - widget.topPadding-widget.bottomPadding,
                width: double.infinity,
                child:
                Listener(
                  child:Image.asset(
                    'images/bg_guanggao.png',
                    fit: BoxFit.fill,
                  ),
                  onPointerDown: (onPointerDownDatas){
                    start_y = onPointerDownDatas.position.dy;
                    LogUtil.e('手势--按下--start_y=${start_y}');
                  },
                  onPointerMove: (onPointerMoveDatas){
                    // LogUtil.e('移动--onPointerMoveDatas=${onPointerMoveDatas}');
                  },
                  onPointerUp: (onPointerUpDatas){
                    end_y = onPointerUpDatas.position.dy;
                    LogUtil.e('手势--抬起--start_y=${start_y};end_y=${end_y}');
                    LogUtil.e('手势--抬起--end_y=${start_y - end_y}');
                    if(start_y > end_y && (start_y - end_y)>60 ){
                      //向上滑动
                      setState(() {
                        _isOpen = false;
                        _toggleAnimation = true;
                      });

                    }
                  },
                )
                ,
              ),
            ),
            _isOpen
                ? Container(
              width: MediaQuery.of(context).size.width,
              height: 90,
              alignment: Alignment.bottomLeft,
              child: IconButton(
                  iconSize: ScreenUtil.getInstance().getWidthPx(60),
                  icon: Image.asset(
                    'assets/images/img_guangao_back.png',
                    fit: BoxFit.cover,
                  ),
                  onPressed: () {
                    setState(() {
                      _isOpen = false;
                      _toggleAnimation = true;
                    });
                  }),
            )
                : Container(
              color: Colors.transparent,
            ),
            Visibility(
              child: Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child:
                Container(
                  alignment: Alignment.center,
                  height: 70,
                  child: DefineHeaderWidget(
                    linkNotifier: widget.linkNotifier,
                  ),
                ),

              ),
              visible: _isHideBottom,
            ),
          ],
        ),
      );


//    );
  }
}
