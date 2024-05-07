import 'package:weihua_flutter/config/storage_manager.dart';
import 'package:weihua_flutter/model/enterprise_info_result.dart';
import 'package:weihua_flutter/model/get_banner_result.dart';
import 'package:weihua_flutter/model/query_workbench_result.dart';
import 'package:weihua_flutter/model/user.dart';
import 'package:weihua_flutter/provider/view_state_model.dart';
import 'package:weihua_flutter/service/account_repository.dart';
import 'package:weihua_flutter/service/app_http_api.dart';
import 'package:weihua_flutter/service/sales_http_api.dart';
import 'package:weihua_flutter/utils/log.dart';

class WorkbenchModel extends ViewStateModel {
  bool _hasNet = true;

  bool get hasNet => _hasNet;
  int _tab = 0;

  int get tab => _tab;

  // late WorkBenchItemGroup _workBenchItemGroup;
  List<WorkBenchItemGroup> _uiGroupList = [];

  List<WorkBenchItemGroup> get uiGroupList => _uiGroupList;

  List<NumberInfo> _enterpriseNumberList = [];
  List<BannerInfo> _perBannerList = [];
  List<BannerInfo> _comBannerList = [];

  List<NumberInfo> get enterpriseList => _enterpriseNumberList;

  List<BannerInfo> get perBannerList =>
      _perBannerList.length > 2 ? _perBannerList.sublist(0, 1) : _perBannerList;

  List<BannerInfo> get comBannerList =>
      _comBannerList.length > 2 ? _comBannerList.sublist(0, 1) : _comBannerList;

  List<NumberInfo> _personalList = [];

  List get personalList => _personalList;
  GetBannerResult _bannerResult =
      GetBannerResult(personList: [], centreList: []);

  GetBannerResult get bannerResult => _bannerResult;

  QueryWorkBenchResult? _workbenchResult;

  QueryWorkBenchResult? get workbenchResult => _workbenchResult;

  String getBusinessId() {
    String businessId = '';
    Log.d('_enterpriseList==${_enterpriseNumberList.toString()}');
    if (_enterpriseNumberList.isEmpty) return businessId;

    for (NumberInfo result in _enterpriseNumberList) {
      if (result.businessInfos.length == 1) {
        businessId = result.businessInfos[0].businessInfoId.toString();
      } else {
        for (BusinessInfos info in result.businessInfos) {
          if (!info.enableUse()) {
            //
            businessId = info.businessInfoId.toString();
          }
        }
      }
    }

    Log.d('businessid==$businessId');
    return businessId;
  }

  void updateNet(bool enable) {
    _hasNet = enable;
    notifyListeners();
  }

  Future queryWorkBench(User user, bool light) async {
    setBusy();
    try {
      _workbenchResult = await httpApi.queryWorkBench(
          user.innerNumberId!, user.outerNumberId, light);

      List<WorkBenchItemGroup> list = [];

      _workbenchResult?.functionList?.forEach((element) {
        list.add(WorkBenchItemGroup.enterpriseInfo(element));
      });

      _uiGroupList = list;

      setIdle();
    } catch (e, s) {
      _uiGroupList.clear();
      setError(e, s);
      // changeWorkbenchTab(1);
      Log.e(e);

      setIdle();
    }
  }

  Future<void> getBanner() async {
    setBusy();
    try {
      _bannerResult = await salesHttpApi.getBanner();
      _perBannerList = _bannerResult.personList;
      _comBannerList = _bannerResult.centreList;
      setIdle();
    } catch (e, s) {
      setError(e, s);
      setIdle();
    }
  }

  void changeWorkbenchTab(int tab) {
    _tab = tab;
    Log.d(comBannerList.toString());
    Log.d(perBannerList.toString());
    if (tab == 1) {
      _uiGroupList = [WorkBenchItemGroup.person()];
    }
    notifyListeners();
  }

  Future getAllNumberInfo(bool light) async {
    setBusy();
    try {
      User user = accRepo.user!;
      // 获取所有号码
      List<NumberInfo> allNumInfoList =
          await salesHttpApi.getAllNumbersInfo(user.mobile!);

      List<NumberInfo> enterpriseNumberList = [];
      List<NumberInfo> personalList = [];

      for (int i = 0; i < allNumInfoList.length; i++) {
        if (allNumInfoList[i].isPersonNumber()) {
          personalList.add(allNumInfoList[i]);
        } else if (allNumInfoList[i].isEnterpriseNumber()) {
          enterpriseNumberList.add(allNumInfoList[i]);
        }
      }
      _personalList = personalList;
      _enterpriseNumberList = enterpriseNumberList;

      if (_enterpriseNumberList.isNotEmpty) {
        // 获取联络中心数据
        queryWorkBench(accRepo.user!, light);
      } else if (_personalList.isNotEmpty) {
        changeWorkbenchTab(1);
      }

      StorageManager.localStorage.setItem("personalList", _personalList);
      StorageManager.localStorage
          .setItem("enterpriseList", _enterpriseNumberList);
      setIdle();
    } catch (e, s) {
      setError(e, s);
      setIdle();
    }
  }

  bool isCurrentEnterpriseNumber(int index) {
    return accRepo.user!.outerNumber == enterpriseList[index].number &&
        accRepo.user!.innerNumber == enterpriseList[index].inner;
  }
}
