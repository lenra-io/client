import 'package:client_common/config/config.dart';
import 'package:client_common/models/auth_model.dart';
import 'package:client_common/models/build_model.dart';
import 'package:client_common/models/cgu_model.dart';
import 'package:client_common/models/store_model.dart';
import 'package:client_common/models/user_application_model.dart';
import 'package:client_store/models/navigation_model.dart';
import 'package:client_store/navigation/url_strategy/url_strategy.dart' show setUrlStrategyTo;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lenra_components/theme/lenra_color_theme_data.dart';
import 'package:lenra_components/theme/lenra_theme.dart';
import 'package:lenra_components/theme/lenra_theme_data.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  // FROM : https://stackoverflow.com/a/64634042
  // configureApp();

  setUrlStrategyTo('path');

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
    String sentryDsn = Config.instance.sentryDsn;
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
        ChangeNotifierProvider<NavigationModel>(create: (context) => NavigationModel())
      ],
      builder: (BuildContext context, _) => LenraTheme(
        themeData: themeData,
        child: MaterialApp.router(
          routerConfig: context.select<NavigationModel, GoRouter>((model) => model.router),
          title: 'Lenra',
          theme: ThemeData(
            visualDensity: VisualDensity.standard,
            textTheme: TextTheme(bodyMedium: themeData.lenraTextThemeData.bodyText),
            scaffoldBackgroundColor: LenraColorThemeData.lenraWhite,
          ),
        ),
      ),
    );
  }
}
