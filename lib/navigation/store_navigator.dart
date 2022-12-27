import 'package:client_common/navigator/common_navigator.dart';
import 'package:client_common/navigator/guard.dart';
import 'package:client_common/navigator/page_guard.dart';
import 'package:client_store/views/app_page.dart';
import 'package:client_store/views/home_page.dart';
import 'package:client_store/views/invitation/invitation_page.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class StoreNavigator extends CommonNavigator {
  static GoRoute app = GoRoute(
    name: "app",
    path: "/app/:appName",
    pageBuilder: (context, state) => NoTransitionPage(
      child: PageGuard(
        guards: [
          Guard.checkAuthenticated,
          Guard.checkCguAccepted,
          Guard.checkIsUser,
        ],
        child: AppPage(
          appName: state.params["appName"]!,
        ),
      ),
    ),
  );

  static GoRoute appInvitation = GoRoute(
    name: "app-invitation",
    path: "/app/invitations/:uuid",
    pageBuilder: (context, state) => NoTransitionPage(
      child: PageGuard(
        guards: [
          Guard.checkAuthenticated,
          Guard.checkCguAccepted,
          Guard.checkIsUser,
        ],
        child: InvitationPage(
          invitationUuid: state.params["uuid"]!,
        ),
      ),
    ),
  );

  static GoRoute home = GoRoute(
    name: "home",
    path: "/",
    pageBuilder: (context, state) => NoTransitionPage(
      child: PageGuard(
        guards: [
          Guard.checkAuthenticated,
          Guard.checkCguAccepted,
          Guard.checkIsUser,
        ],
        child: const HomePage(),
      ),
    ),
  );

  static String buildAppRoute(String appName) => "/app/$appName";

  static final GoRouter router = GoRouter(
    routes: [
      ...CommonNavigator.authRoutes,
      home,
      app,
      appInvitation,
    ],
  );
}

class FadeInTransitionPage extends CustomTransitionPage {
  FadeInTransitionPage({required Widget child, LocalKey? key})
      : super(
          child: child,
          key: key,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Change the opacity of the screen using a Curve based on the the animation's
            // value
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
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
