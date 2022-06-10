import 'package:client_app/app.dart';
import 'package:client_app/models/channel_model.dart';
import 'package:client_app/models/client_widget_model.dart';
import 'package:client_common/models/user_application_model.dart';
import 'package:client_common/navigator/common_navigator.dart';
import 'package:client_common/navigator/guard.dart';
import 'package:client_common/navigator/page_guard.dart';
import 'package:client_common/views/page_404.dart';
import 'package:client_store/views/home_page.dart';
import 'package:flutter/widgets.dart';
import 'package:lenra_ui_runner/widget_model.dart';
import 'package:provider/provider.dart';

class BackofficeNavigator extends CommonNavigator {
  static const String homeRoute = "/";
  static const String appRoute = "/app/:appName";
  static String? currentRoute;
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final Map<String, CustomPageBuilder> routes = {}
    ..addAll(CommonNavigator.authRoutes)
    ..addAll(appRoutes);

  static final Map<String, CustomPageBuilder> appRoutes = {
    homeRoute: (Map<String, String> params) => PageGuard(
          guards: [
            Guard.checkAuthenticated,
            Guard.checkCguAccepted,
            Guard.checkIsUser,
          ],
          child: const HomePage(),
        ),
    appRoute: (Map<String, String> params) => PageGuard(
          onInit: (context) {
            context.read<UserApplicationModel>().currentApp = params["appName"];
            context.read<ChannelModel>().createChannel(params["appName"]!);
            (context.read<WidgetModel>() as ClientWidgetModel).setupListeners();
          },
          guards: [
            Guard.checkAuthenticated,
            Guard.checkCguAccepted,
            Guard.checkIsUser,
          ],
          builder: (context) {
            // TODO : Set accessToken
            return  App(accessToken: '', appName: params["appName"]!,);
          },
        )
  };

  static Widget? _getPageForRoutes(
    List<String> currentRouteParts,
    String route,
    CustomPageBuilder routeBuilder,
  ) {
    Map<String, String> params = {};
    List<String> routeParts = route.split('/');
    if (routeParts.length != currentRouteParts.length) return null;
    for (int i = 0; i < routeParts.length; i++) {
      String routePart = routeParts[i];
      String currentRoutePart = currentRouteParts[i];

      if (routePart.startsWith(':')) {
        params[routePart.replaceFirst(':', '')] = currentRoutePart;
      } else if (routePart != currentRoutePart) {
        return null;
      }
    }

    return routeBuilder(params);
  }

  static Widget? _getFirstMatchingPage(String route) {
    List<String> currentRouteParts = route.split('/');
    for (MapEntry<String, CustomPageBuilder> entry in routes.entries) {
      Widget? page = _getPageForRoutes(currentRouteParts, entry.key, entry.value);
      if (page != null) {
        return page;
      }
    }
    return null;
  }

  static Route<dynamic> handleGenerateRoute(RouteSettings settings) {
    debugPrint("route: ${settings.name}");
    BackofficeNavigator.currentRoute = settings.name;
    if (settings.name == null) return Page404.pageRoutebuilder(settings);
    Widget? page = _getFirstMatchingPage(settings.name!);
    if (page == null) return Page404.pageRoutebuilder(settings);
    return PageRouteBuilder(
      pageBuilder: (BuildContext context, _a, _b) {
        return page;
      },
      settings: settings,
    );
  }
}
