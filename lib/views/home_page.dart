import 'package:client_common/api/response_models/app_response.dart';
import 'package:client_common/models/auth_model.dart';
import 'package:client_common/models/user_application_model.dart';
import 'package:client_common/navigator/common_navigator.dart';
import 'package:client_common/navigator/guard.dart';
import 'package:client_store/models/navigation_model.dart';
import 'package:client_store/navigation/store_navigator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lenra_components/component/lenra_dropdown_button.dart';
import 'package:lenra_components/component/lenra_text.dart';
import 'package:lenra_components/lenra_components.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isInitialized = false;
  bool showDropdown = false;
  List<AppResponse>? openedApps;

  @override
  void initState() {
    context.read<UserApplicationModel>().getAppsUserOpened().then((value) {
      setState(() {
        openedApps = value;
        isInitialized = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) return const Center(child: CircularProgressIndicator());
    return Scaffold(
      body: LenraFlex(
        direction: Axis.vertical,
        fillParent: true,
        spacing: 24,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Color(0x1A000000),
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: LenraFlex(
              mainAxisAlignment: MainAxisAlignment.end,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              fillParent: true,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      showDropdown = true;
                    });
                  },
                  child: LenraDropdownButton(
                    icon: null,
                    type: LenraComponentType.tertiary,
                    text: "Menu",
                    child: LenraFlex(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      direction: Axis.vertical,
                      children: [
                        InkWell(
                          onTap: () {
                            CommonNavigator.go(context, CommonNavigator.profile);
                          },
                          child: const Text("Profile"),
                        ),
                        InkWell(
                          onTap: () {
                            context.read<AuthModel>().logout().then((_) {
                              CommonNavigator.go(context, StoreNavigator.home);
                            });
                          },
                          child: const Text("Disconnect"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          LenraFlex(
            children: [
              LenraButton(
                text: "Add test route",
                onPressed: () {
                  GoRoute test = GoRoute(
                      name: "appTest",
                      path: "/app/name/:path(.*)",
                      redirect: (context, state) => Guard.guards(context, [
                            Guard.checkAuthenticated,
                            Guard.checkCguAccepted,
                            Guard.checkIsUser,
                          ]),
                      pageBuilder: (context, state) {
                        print("TEST");
                        print(state.params);
                        return NoTransitionPage(
                          child: const SafeArea(
                            child: Text("App Test"),
                          ),
                        );
                      });

                  context.read<NavigationModel>().addTestRoute(test);
                },
              ),
              LenraButton(
                text: "Navigate to app routes",
                onPressed: () {
                  CommonNavigator.goPath(context, "/app/name/test");
                },
              ),
            ],
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 24,
                runSpacing: 8,
                children: openedApps!.map((app) => ApplicationCard(app: app)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ApplicationCard extends StatelessWidget {
  final AppResponse app;

  const ApplicationCard({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    var themeData = LenraThemeData();
    return Container(
      constraints: const BoxConstraints(minWidth: 80, maxWidth: 80),
      child: InkWell(
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: () {
          CommonNavigator.goPath(context, "/app/${app.serviceName}");
        },
        child: LenraFlex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.center,
          padding: const EdgeInsets.all(8),
          spacing: 8,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: app.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: LenraText(
                  style: themeData.lenraTextThemeData.headline1,
                  textAlign: TextAlign.center,
                  text: app.name[0].toUpperCase(),
                ),
              ),
            ),
            LenraText(
              style: themeData.lenraTextThemeData.bodyText,
              textAlign: TextAlign.center,
              text: app.name,
            ),
          ],
        ),
      ),
    );
  }
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
