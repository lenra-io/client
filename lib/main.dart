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
import 'package:lenra_ui_runner/models/app_socket_model.dart';
import 'package:lenra_ui_runner/models/socket_model.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  // FROM : https://stackoverflow.com/a/64634042
  // configureApp();

  Logger.root.level = Level.WARNING;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  debugPrint("Starting main app[debugPrint]: ${Config.instance.application}");
  // ignore: todo
  // TODO: Récupération de variables d'environnement ne doit pas marcher
  const environment = String.fromEnvironment('ENVIRONMENT');

  if (environment == "production" || environment == "staging") {
    const sentryDsn = String.fromEnvironment('SENTRY_CLIENT_DSN');
    await SentryFlutter.init(
      (options) => options
        ..dsn = sentryDsn
        ..environment = environment,
      appRunner: () => runApp(const Store()),
    );
  } else {
    runApp(const Store());
  }
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
        ChangeNotifierProvider<StoreModel>(create: (context) => StoreModel()),
        ChangeNotifierProvider<CguModel>(create: (context) => CguModel()),
        ChangeNotifierProvider<UserApplicationModel>(create: (context) => UserApplicationModel()),
        ChangeNotifierProxyProvider<AuthModel, SocketModel>(
          create: (context) => AppSocketModel(context.read<AuthModel>().accessToken ?? ""),
          update: (_, authModel, socketModel) {
            if (socketModel == null) {
              return AppSocketModel(authModel.accessToken ?? "");
            }

            (socketModel as AppSocketModel).update(authModel.accessToken ?? "");
            return socketModel;
          },
        ),
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
