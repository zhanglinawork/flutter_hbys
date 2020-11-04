enum NetStatus { Enable, Disable }
enum NetType { wifi, mobile, none }
/*
 *网络状态的类
 *@author zln
 *create at 2020/10/27 下午2:53
 */
class AppStatusModel {
  static AppStatusModel _singleton;
  static AppStatusModel _getInstance() {
    if (_singleton == null) {
      _singleton = AppStatusModel();
    }
    return _singleton;
  }

  factory AppStatusModel() => _getInstance();


  //网络是否可用
  NetStatus netStatus = NetStatus.Enable;
/*
 *设置网络状态
 *@author zln
 *create at 2020/10/27 下午2:50
 */
  setNetStatus(NetStatus status) {
    netStatus = status;
  }

//网络连接方式
  NetType netType;
/*
 *设置网络连接方式
 *@author zln
 *create at 2020/10/27 下午2:51
 */
  setNetType(NetType type) {
    netType = type;
  }
}


