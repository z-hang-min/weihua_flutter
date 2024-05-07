import 'package:weihua_flutter/model/notification_model_result.dart';
import 'package:weihua_flutter/provider/view_state_refresh_list_model.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';

/// 通知模板相关
class NotificationTempleModel
    extends ViewStateRefreshListModel<NotificationTemple> {
  // 模板列表数据
  // List<NotificationTemple> templeList = [];

  String mobile = accRepo.user!.mobile!;

  // ============= 模板修改 页面状态 start
  String _tempName = "";

  String get tempName => _tempName;
  String _tempContent = "";
  String get tempContent => _tempContent;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  void updateTempName(String name){
    _tempName = name;
    notifyListeners();
  }

  void updateTempContent(String content){
    _tempContent = content;
    // 不需要刷新页面
    //notifyListeners();
  }

  /// 转换 播放状态
  void togglePlayState(){
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  // ============= 模板修改 页面状态 end





  /// 增加模板
  Future<bool> addNotificationModel() async {
    setBusy();
    try {
      await salesHttpApi.addNotificationModel(mobile, _tempName, _tempContent);
      setIdle();
      return true;
    } catch (e, s) {
      setIdle();
      setError(e, s);
      return false;
    }
  }

  /// 修改模板
  Future<bool> updateNotificationModel(String templateName,
      String templateContent, String templateId) async {
    setBusy();
    try {
      await salesHttpApi.updateNotificationModel(mobile, templateName, templateContent, templateId);
      setIdle();
      return true;
    } catch (e, s) {
      setIdle();
      setError(e, s);
      return false;
    }
  }

  /// 删除模板
  Future<bool> deleteNotificationModel(NotificationTemple temple) async {
    setBusy();
    try {
      await salesHttpApi.deleteNotificationTemplate(
          mobile, temple.templateId.toString());
      list.remove(temple);
      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      setIdle();
      return false;
    }
  }

  ///
  Future<String> textToVoice() async {
    setBusy();
    try {
      String text = await salesHttpApi.textToVoice(mobile, _tempContent);
      setIdle();
      return text;
    } catch (e, s) {
      setError(e, s);
      setIdle();
      return "";
    }
  }

  @override
  Future<List<NotificationTemple>> loadData({int pageNum = 1}) async {
    NotificationModelResult result =
        await salesHttpApi.getNotificationModel(mobile, pageNum, pageSize);
    return result.dataList;
  }
}
