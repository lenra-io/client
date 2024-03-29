import 'package:client/navigation/guard.dart';
import 'package:client/views/app_page.dart';
import 'package:client/views/home_page.dart';
import 'package:client/views/invitation/invitation_page.dart';
import 'package:client/views/oauth_page.dart';
import 'package:client/views/profile_page/profile_page.dart';
import 'package:client_common/navigator/common_navigator.dart';
import 'package:client_common/navigator/guard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StoreNavigator extends CommonNavigator {
  static GoRoute oauth = GoRoute(
    name: "oauth",
    path: "/oauth",
    builder: (ctx, state) => const SafeArea(child: OAuthPage()),
  );

  static GoRoute app = GoRoute(
    name: "app",
    path: "app/:appName:path(\\/?.*)",
    pageBuilder: (context, state) => NoTransitionPage(
      key: state.pageKey,
      child: SafeArea(
        child: AppPage(
          appName: state.params["appName"]!,
          path: state.params['path']!,
        ),
      ),
    ),
  );

  static GoRoute appInvitation = GoRoute(
    name: "app-invitation",
    path: "app/invitations/:uuid",
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
    pageBuilder: (context, state) => ScaleTopRightTransitionPage(
      child: const SafeArea(
        child: ProfilePage(),
      ),
    ),
  );

  static GoRoute home = GoRoute(
      name: "home",
      path: "/",
      pageBuilder: (context, state) => NoTransitionPage(
            child: const SafeArea(
              child: HomePage(),
            ),
          ),
      redirect: (context, state) => Guard.guards(
            context,
            [
              ClientGuard.checkIsAuthenticated,
            ],
            metadata: {"initialRoute": state.location},
          ),
      routes: [profile, appInvitation, app]);

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
