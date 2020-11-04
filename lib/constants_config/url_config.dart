import 'package:common_utils/common_utils.dart';

///配置请求网络的基地址
class UrlConfig {
  //是否是生产环境
  static final isProduct = const bool.fromEnvironment('dart.vm.product');

  static int configStatus = 0; //0代表测试环境，1代表预发布环境
  static const uatUrls = [
    "https://uatapi.huobanys.com/", //测试环境
    "https://preapi.huobanys.com/", //预发布环境
    "https://lsapi.huobanys.com/" //线上环境
  ];
  static const javaUrls = [
    "http://47.95.198.177:8920/", //测试环境
    "https://testapi.huobanys.com/", //预发布环境
    "https://lsapi.huobanys.com/" //线上环境
  ];

  static const h5Urls = [
    "https://testh5.huobanys.com/#", //测试环境
    "https://uath5.huobanys.com/#", //预发布环境
    "https://h5.huobanys.com/#" //线上环境
  ];

  static const productUrls = [
    "https://wxh5test.huobanys.com/", //测试环境
    "https://wxh5uat.huobanys.com/", //预发布环境
    "https://wxh5.huobanys.com/" //线上环境
  ];

  static const imUrls = [
    "https://imh5test.huobanys.com/#/conversation?", //测试环境
    "https://imh5test.huobanys.com/#/conversation?", //预发布环境
    "https://imh5.huobanys.com/#/conversation?" //线上环境
  ];

  ///获取baseurl
  static String getBaseUrl(String type) {
    var urls = javaUrls;
    switch (type) {
      case "uat":
        urls = uatUrls;
        break;
      case "java":
        urls = javaUrls;
        break;
      case "h5":
        urls = h5Urls;
        break;
      case "product":
        urls = productUrls;
        break;
      case "IM":
        urls = imUrls;
        break;
    }

    String BaseUrl;
    if (!isProduct) {
      BaseUrl = urls[configStatus];
    } else {
      BaseUrl = urls[2];
    }
    LogUtil.e("configStatus= $configStatus;baseurl=$BaseUrl ");
    return BaseUrl;
  }

  static String HOST_JAVA = getBaseUrl("uat");
  static String HOST_JAVA_NEW = getBaseUrl("java");//新接口
  static String H5_URL = getBaseUrl("h5");//新增加的h5
  static String IM_HOST_URL = getBaseUrl("IM");
  static String H5_URL_PRODUCT = getBaseUrl("product");

  static String H5_VIDEOINQUIRY = H5_URL_PRODUCT + "videoqr";//视频问诊二维码页面
  static String H5_SELECTPERSON = H5_URL_PRODUCT + "person";//选择联系人h5页面
  static String COMMEN_PROBLEM = "https://mainapp.huobanys.com/ffaq_index.html";//常见问题
}
