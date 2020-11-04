
import 'package:fbutton/fbutton.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_baseframwork/base_framework/utils/image_helper.dart';

class CommonEmptyView extends StatefulWidget {

  int ViewState = 0;//0代表订单没有数据，1代表报告没有数据，2代表没有关注，3代表加载失败
  String imgName = "";
  String viewTip = "";
  int requestType;
  String btnText ;//按钮上显示的文本
  bool isBtnVisiable = false;//按钮是否显示
  Function mReLoad;

  CommonEmptyView({this.mReLoad});

  @override
  _CommonEmptyViewState createState() => _CommonEmptyViewState();

  isShowButton(){
    bool isVisiable = false ;
    String showText = "去购买" ;
    if(ViewState == 3 || requestType == null){
      isVisiable = false;
    }else{
      if (requestType == 53 || requestType == 54 || requestType == 112) {
        isVisiable = true;
        showText="去问诊";
      } else if (requestType == 29 || requestType == 12
          || requestType == 13 || requestType == 55) {
        showText="去购买";
        isVisiable = true;
      } else if (requestType >= 20 && requestType <= 26) {
        //特色服务
        isVisiable = true;
        showText="去咨询";
      } else if (requestType == 111) {
        //视频问诊
        isVisiable = true;
        showText="去咨询";
      } else {
        isVisiable = false;
      }
    }
    // setState(() {
    isBtnVisiable = isVisiable;
    btnText = showText;
    // });
  }

  Widget ChangeView(int type,{int requestType,Function reLoad}){
    int mPageType = type;
    int mRequestType = -1;
    String mImgName = "img_common_empty";
    String mViewTip = "空空如也～";
    Function mReLoad;
    if(requestType != null){
      mRequestType = requestType;
    }
    if(reLoad != null){
      mReLoad = reLoad;
    }
    switch(type){
      case 0:
        mImgName = "img_common_empty";
        mViewTip = "空空如也～";
        break;
      case 1:
        mImgName = "img_common_onreport";
        mViewTip = "暂时没有相关记录吆!";
        break;
      case 2:
        mImgName = "img_common_noguanzhu";
        mViewTip = "您暂时还没有收藏吆！";
        break;
      case 3:
        mImgName = "img_common_loadfail";
        mViewTip = "加载错误，请重试";
        break;
      case 4:
        mImgName = "img_common_empty";
        mViewTip = "没有找到相关数据";
        break;
      case 5:
        mImgName = "img_common_empty";
        mViewTip = "暂时没有相关企业";
        break;
    }
    // setState(() {
    imgName = mImgName;
    viewTip = mViewTip;
    ViewState = mPageType;
    requestType = mRequestType;
    mReLoad = mReLoad;
    // });
    isShowButton();
  }


}

class _CommonEmptyViewState extends State<CommonEmptyView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextUtil.isEmpty(widget.imgName)?Container():
           Image.asset(ImageHelper.wrapAssets("${widget.imgName}"),
             package: "flutter_plugin_baseframwork",fit: BoxFit.cover,
             width: 150,
           ),
           Padding(
             padding: EdgeInsets.only(top: 20),
             child: GestureDetector(
               onTap: (){
                 if(widget.ViewState == 3){
                   //todo 点击重新请求数据
                   if(widget.mReLoad != null){
                     widget.mReLoad();
                   }
                 }
               },
               child: widget.ViewState == 3?Container(
                 child: RichText(
                     text: TextSpan(text: '加载错误，请',style: TextStyle(color: Colors.black54),
                         children: <TextSpan>[
                           TextSpan(text: '重试!',style: TextStyle(color: Colors.green)),
                         ]
                     )
                 ),
               ):Text("${widget.viewTip}",),
             ),
           ),
           Visibility(
             visible: widget.isBtnVisiable,
             child:
                 Padding(
                   padding: EdgeInsets.only(top: 20),
                   child:  FButton(padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                     text: "${widget.btnText}",
                     style: TextStyle(color: Colors.green),
                     color: Colors.white,
                     corner: FCorner.all(6.0),
                     strokeWidth: 1,
                     strokeColor: Colors.green,
                     onPressed: (){
                       //todo 点击按钮
                     },
                   ),
                 ),

           )
        ],
      ),
    );
  }


}

