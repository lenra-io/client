import 'package:client_app/models/app_socket_model.dart';
import 'package:client_app/models/channel_model.dart';
import 'package:client_app/models/client_widget_model.dart';
import 'package:client_app/models/socket_model.dart';
import 'package:client_common/config/config.dart';
import 'package:client_common/models/auth_model.dart';
import 'package:client_common/models/build_model.dart';
import 'package:client_common/models/cgu_model.dart';
import 'package:client_common/models/store_model.dart';
import 'package:client_common/models/user_application_model.dart';
import 'package:client_store/navigation/store_navigator.dart';
import 'package:flutter/material.dart';
import 'package:lenra_components/theme/lenra_theme.dart';
import 'package:lenra_components/theme/lenra_theme_data.dart';
import 'package:lenra_ui_runner/lenra_application_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const Store());
}

class Store extends StatelessWidget {
  const Store({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = LenraThemeData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthModel>(create: (context) => AuthModel()),
        ChangeNotifierProvider<BuildModel>(create: (context) => BuildModel()),
        ChangeNotifierProvider<UserApplicationModel>(create: (context) => UserApplicationModel()),
        ChangeNotifierProvider<StoreModel>(create: (context) => StoreModel()),
        ChangeNotifierProvider<CguModel>(create: (context) => CguModel()),
        ChangeNotifierProxyProvider2<UserApplicationModel, AuthModel, LenraApplicationModel>(
            create: (context) => LenraApplicationModel(
                  Config.instance.httpEndpoint,
                  context.read<UserApplicationModel>().currentApp ?? "",
                  context.read<AuthModel>().accessToken ?? "",
                ),
            update: (_, userApplicationModel, authModel, applicationModel) {
              return LenraApplicationModel(
                Config.instance.httpEndpoint,
                userApplicationModel.currentApp ?? "",
                authModel.accessToken ?? "",
              );
            }),
      ],
      builder: (BuildContext context, _) => LenraTheme(
        themeData: themeData,
        child: MaterialApp(
          title: 'Lenra',
          navigatorKey: StoreNavigator.navigatorKey,
          onGenerateInitialRoutes: (initialRoute) =>
              [StoreNavigator.handleGenerateRoute(RouteSettings(name: initialRoute))],
          onGenerateRoute: StoreNavigator.handleGenerateRoute,
          theme: ThemeData(
            textTheme: TextTheme(bodyText2: themeData.lenraTextThemeData.bodyText),
          ),
        ),
      ),
    );
  }
}
