import 'package:client_common/navigator/common_navigator.dart';
import 'package:client_store/navigation/store_navigator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The model that manages the navigation inside of an application.
class NavigationModel extends ChangeNotifier {
  late List<RouteBase> appRoutes = [];

  late GoRouter router = GoRouter(
    routes: [
      CommonNavigator.authRoutes,
      // Onboarding & other pages
      StoreNavigator.home,
      ...appRoutes
    ],
  );

  void addTestRoute(GoRoute test) {
    appRoutes = [test];

    router = GoRouter(
      routes: [
        CommonNavigator.authRoutes,
        // Onboarding & other pages
        StoreNavigator.home,
        ...appRoutes
      ],
    );

    notifyListeners();
  }
}
