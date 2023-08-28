import 'package:catcher/catcher.dart';
import 'package:client/navigation/store_navigator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The model that manages the navigation inside of an application.
class NavigationModel extends ChangeNotifier {
  late List<RouteBase> appRoutes = [];

  late GoRouter router = GoRouter(
    navigatorKey: Catcher.navigatorKey,
    routes: [
      // Onboarding & other pages
      StoreNavigator.home,
      StoreNavigator.oauth,
      ...appRoutes,
    ],
  );
}
