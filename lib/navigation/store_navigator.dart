import 'package:client_common/config/config.dart';
import 'package:client_common/navigator/common_navigator.dart';
import 'package:client_common/navigator/guard.dart';
import 'package:client_store/views/app_page.dart';
import 'package:client_store/views/home_page.dart';
import 'package:client_store/views/invitation/invitation_page.dart';
import 'package:client_store/views/profile_page/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lenra_ui_runner/app.dart';

class StoreNavigator extends CommonNavigator {
  static GoRoute appRoutes = GoRoute(
      name: "appRoutes",
      path: ":path(.*)",
      pageBuilder: (context, state) {
        print("APP ROUTES ROUTE");
        print(state.params);
        return NoTransitionPage(
          child: App(
            appName: state.params["appName"]!,
            httpEndpoint: Config.instance.httpEndpoint,
            accessToken: "",
            wsEndpoint: Config.instance.wsEndpoint,
            baseRoute: "/",
            routeWidget: LenraRoute(
              "/${state.params['path']!}",
              // Use UniqueKey to make sure that the LenraRoute Widget is properly reloaded with the new route when navigating.
              key: UniqueKey(),
            ),
            navTo: (context, route) {
              GoRouter.of(context).go(route);
            },
          ),
        );
      });

  static GoRoute app = GoRoute(
      name: "app",
      path: "app/:appName",
      routes: [
        appRoutes,
      ],
      redirect: (context, state) => Guard.guards(context, [
            Guard.checkAuthenticated,
            Guard.checkCguAccepted,
            Guard.checkIsUser,
          ]),
      pageBuilder: (context, state) {
        print("APP ROUTE");
        print(state.params);
        return NoTransitionPage(
          key: state.pageKey,
          child: SafeArea(
            child: AppPage(
              appName: state.params["appName"]!,
            ),
          ),
        );
      });

  static GoRoute appInvitation = GoRoute(
    name: "app-invitation",
    path: "app/invitations/:uuid",
    redirect: (context, state) => Guard.guards(context, [
      Guard.checkAuthenticated,
      Guard.checkCguAccepted,
      Guard.checkIsUser,
    ]),
    pageBuilder: (context, state) => NoTransitionPage(
      child: SafeArea(
        child: InvitationPage(
          invitationUuid: state.params["uuid"]!,
        ),
      ),
    ),
  );

  static GoRoute profile = GoRoute(
    name: "profile",
    path: "profile",
    redirect: (context, state) => Guard.guards(context, [
      Guard.checkAuthenticated,
      Guard.checkCguAccepted,
      Guard.checkIsUser,
    ]),
    pageBuilder: (context, state) => ScaleTopRightTransitionPage(
      child: const SafeArea(
        child: ProfilePage(),
      ),
    ),
  );

  static GoRoute home = GoRoute(
      name: "home",
      path: "/",
      redirect: (context, state) => Guard.guards(context, [
            Guard.checkAuthenticated,
            Guard.checkCguAccepted,
            Guard.checkIsUser,
          ]),
      pageBuilder: (context, state) => NoTransitionPage(
            child: const SafeArea(
              child: HomePage(),
            ),
          ),
      routes: [appInvitation, app, profile]);

  static String buildAppRoute(String appName) => "/app/$appName";
}

class ScaleTopRightTransitionPage extends CustomTransitionPage {
  ScaleTopRightTransitionPage({required Widget child, LocalKey? key})
      : super(
          child: child,
          key: key,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Change the opacity of the screen using a Curve based on the the animation's
            // value
            return ScaleTransition(
              alignment: Alignment.topRight,
              scale: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
}

class NoTransitionPage extends CustomTransitionPage {
  NoTransitionPage({required Widget child, LocalKey? key})
      : super(
          child: child,
          key: key,
          transitionDuration: Duration.zero,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        );
}
