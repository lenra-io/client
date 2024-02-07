import 'package:client/navigation/store_navigator.dart';
import 'package:client_common/config/config.dart';
import 'package:client_common/oauth/oauth_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lenra_ui_runner/app.dart';
import 'package:lenra_ui_runner/io_components/lenra_route.dart';
import 'package:lenra_ui_runner/models/app_socket_model.dart';
import 'package:lenra_ui_runner/models/socket_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AppPage extends StatelessWidget {
  final String appName;
  final String path;

  const AppPage({required this.appName, required this.path, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<OAuthModel, SocketModel>(
          create: (context) => AppSocketModel(context.read<OAuthModel>().accessToken?.accessToken ?? "", appName),
          update: (_, oauthModel, socketModel) {
            if (socketModel == null) {
              return AppSocketModel(oauthModel.accessToken?.accessToken ?? "", appName);
            }

            (socketModel as AppSocketModel).update(oauthModel.accessToken?.accessToken ?? "");
            return socketModel;
          },
        ),
      ],
      builder: (BuildContext context, _) => App(
        appName: appName,
        accessToken: context.watch<OAuthModel>().accessToken?.accessToken ?? "",
        httpEndpoint: Config.instance.httpEndpoint,
        wsEndpoint: Config.instance.wsEndpoint,
        baseRoute: "/app/$appName",
        routeWidget: LenraRoute(
          "/$path",
          // Use UniqueKey to make sure that the LenraRoute Widget is properly reloaded with the new route when navigating.
          key: UniqueKey(),
        ),
        navTo: (context, route) {
          // This regex matches http:// and https:// urls
          RegExp exp = RegExp(r"^https?://");
          if (exp.hasMatch(route)) {
            _launchURL(route);
          } else {
            GoRouter.of(context).go("${StoreNavigator.buildAppRoute(appName)}$route");
          }
        },
      ),
    );
  }
}

_launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw Exception("Could not launch url: $url");
  }
}
