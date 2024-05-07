///

///
/// @Desc: App 配置
///
/// @Author: zhhli
///
/// @Date: 2021/4/14
///
class ConstConfig {
  static const isDebug = false;
  static const http_api_url =
      isDebug ? "http://39.97.232.211:8070" : "http://whtest.95013.com:8070";

  //购买相关地址
  static const http_api_url_sales = isDebug
      ? "http://devtest.95013.com:8022"
      : "http://whtest.95013.com:8022";
  static const osinfo = isDebug ? "osinfo" : "V1.2.5.0@osinfo";
  static const pay_type_buyNum = 1; //购买新号码
  static const pay_type_upgrade = 2; //升级支付
  static const pay_type_renew = 3; //号码续费
  static const pay_type_charge = 4; //次数充值
  static const pay_type_buyext = 5; //购买分机
  static const pay_type_renewext = 6; //分机续费
  static const package_type_upgrade = 'whUpgrade';
  static const package_type_renew = 'whRenew';
  static const package_type_count = 'whVoice';
  static const package_type_inner = 'whInner'; //分机购买套餐

  // &modeType=1
  // modeType是1的时候就是深色模式，不加或者值是其它的话就和原来一样无变化
  static const String user_agreement =
      'https://whtest.95013.com/ipcboss/weihua/useragreement?modeType=';

  static const String privacy =
      'https://whtest.95013.com/ipcboss/weihua/privacypolicy?modeType=';
}
