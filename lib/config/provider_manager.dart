import 'package:weihua_flutter/ui/page/contact/view_model/home_enterprise_address_model.dart';
import 'package:weihua_flutter/view_model/locale_model.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:weihua_flutter/view_model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

UserModel _userModel = UserModel();

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

/// 独立的model
List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider<ThemeModel>(
    create: (context) => ThemeModel(),
  ),
  ChangeNotifierProvider<LocaleModel>(
    create: (context) => LocaleModel(),
  ),
  ChangeNotifierProvider<HomeBusinessContactModel>(
    create: (context) => HomeBusinessContactModel(_userModel),
  ),

  // ChangeNotifierProvider<GlobalFavouriteStateModel>(
  //   create: (context) => GlobalFavouriteStateModel(),
  // )
];

/// 需要依赖的model
///
List<SingleChildWidget> dependentServices = [
  /// UserModel依赖globalFavouriteStateModel
  // ChangeNotifierProxyProvider<GlobalFavouriteStateModel, UserModel>(
  //   create: null,
  //   update: (context, globalFavouriteStateModel, userModel) =>
  //   userModel ??
  //       UserModel(globalFavouriteStateModel: globalFavouriteStateModel),
  // )

  ChangeNotifierProvider<UserModel>(
    create: (context) => _userModel,
  ),
];

List<SingleChildWidget> uiConsumableProviders = [
//  StreamProvider<User>(
//    builder: (context) => Provider.of<AuthenticationService>(context, listen: false).user,
//  )
];
