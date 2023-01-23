import 'package:client_common/navigator/common_navigator.dart';
import 'package:client_common/navigator/guard.dart';
import 'package:client_store/views/app_page.dart';
import 'package:client_store/views/home_page.dart';
import 'package:client_store/views/invitation/invitation_page.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class StoreNavigator extends CommonNavigator {
  static GoRoute app = GoRoute(
    name: "app",
    path: "app/:appName",
    redirect: (context, state) => Guard.guards(context, [
      Guard.checkAuthenticated,
      Guard.checkCguAccepted,
      Guard.checkIsUser,
    ]),
    pageBuilder: (context, state) => NoTransitionPage(
      child: SafeArea(
        child: AppPage(
          appName: state.params["appName"]!,
        ),
      ),
    ),
  );

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

  static GoRoute home = GoRoute(
    name: "home",
    path: "home",
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
  );

  static GoRoute root = GoRoute(
      name: "root",
      path: "/",
      pageBuilder: (context, state) {
        return NoTransitionPage(
          key: state.pageKey,
          child: Builder(builder: (context) {
            if (GoRouter.of(context).location == "/") {
              WidgetsBinding.instance.addPostFrameCallback(((_) {
                router.goNamed(home.name!);
              }));
            }
            return Container();
          }),
        );
      },
      routes: [
        CommonNavigator.authRoutes,
        // Onboarding & other pages
        home,
        appInvitation,
        app,
      ]);

  static String buildAppRoute(String appName) => "/app/$appName";

  static final GoRouter router = GoRouter(
    routes: [root],
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
