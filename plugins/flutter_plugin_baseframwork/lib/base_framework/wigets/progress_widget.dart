import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_baseframwork/base_framework/utils/image_helper.dart';
import 'package:flutter_plugin_baseframwork/base_framework/view/base_stateless_widget.dart';
import 'package:flutter_plugin_baseframwork/base_framework/view/widget_state.dart';

class CircleProgressWidget extends BaseStatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Container(

      width: getWidthPx(150),
      height: getWidthPx(150),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(getHeightPx(15)),
        color: Colors.white,
      ),
      child: Container(
        width: getWidthPx(60),
        height: getWidthPx(60),
        // child: CircularProgressIndicator(),
        child:ImageHelper.FirstloadingWidget(),
      ),
    );
  }

}

///显示progress 方式 1
///这种方式，需要在布局中添加FullPageCircleProgressWidget
class FullPageCircleProgressWidget extends BaseStatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
//      height: getWidthPx(1334),
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      color: Color.fromRGBO(34, 34, 34, 0.3),
      child: ImageHelper.FirstloadingWidget(),
    );
  }

}

///显示progress 方式 2
///这种方式，不需要在布局中添加

//typedef LoadingCreate = void Function(DialogLoadingController controller);


class LoadingProgressState extends WidgetState {

  final Widget progress;
  final Color bgColor;
  //final LoadingCreate loadingCreate;
  final DialogLoadingController controller;

  LoadingProgressState({this.progress, this.bgColor, this.controller});


  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      if(controller.isShow){
        //todo
      }else{
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pop();
        });
      }
    });
  }

  @override
  void dispose() {
    debugPrint("progresswidget-------dispose()-------");
    controller.isShow = false;
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      color: bgColor??Color.fromRGBO(34, 34, 34, 0.3),
      width: size.width,height: size.height,
      alignment: Alignment.center,
      child:progress?? ImageHelper.FirstloadingWidget(),
    );
  }
}

class DialogLoadingController extends ChangeNotifier{
  bool isShow = true;
  dismissDialog(){
    isShow = false;
    notifyListeners();
  }
}


