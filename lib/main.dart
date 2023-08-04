import 'package:catcher/catcher.dart';
import 'package:client/models/navigation_model.dart';
import 'package:client/navigation/url_strategy/url_strategy.dart' show setUrlStrategyTo;
import 'package:client_common/config/config.dart';
import 'package:client_common/models/auth_model.dart';
import 'package:client_common/models/build_model.dart';
import 'package:client_common/models/store_model.dart';
import 'package:client_common/models/user_application_model.dart';
import 'package:client_common/oauth/oauth_model.dart';
import 'package:client_common/views/auth/oauth_page.dart';
import 'package:client_common/views/lenra_report_mode.dart';
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

  CatcherOptions debugOptions = CatcherOptions(
    LenraReportMode(),
    environment == "production" || environment == "staging"
        ? [
            SentryHandler(
              SentryClient(SentryOptions(dsn: Config.instance.sentryDsn)..environment = environment),
            ),
          ]
        : [],
  );

  Catcher(
    debugConfig: debugOptions,
    rootWidget: const Store(),
  );
}

class Store extends StatelessWidget {
  const Store({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = LenraThemeData();

    return Container(
      color: Colors.white,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<OAuthModel>(
            create: (context) => OAuthModel(
              'bf8c0800-6172-4816-8957-37684680361d',
              const String.fromEnvironment("OAUTH_REDIRECT_URL", defaultValue: "http://localhost:10000/redirect.html"),
              scopes: ['resources', 'manage:account', 'store'],
            ),
          ),
          ChangeNotifierProvider<AuthModel>(create: (context) => AuthModel()),
          ChangeNotifierProvider<BuildModel>(create: (context) => BuildModel()),
          ChangeNotifierProvider<StoreModel>(create: (context) => StoreModel()),
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
            builder: (context, widget) {
              return OAuthPage(child: widget!);
            },
          ),
        ),
      ),
    );
  }
}
