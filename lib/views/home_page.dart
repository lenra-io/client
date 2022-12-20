import 'package:client_common/api/response_models/app_response.dart';
import 'package:client_common/models/auth_model.dart';
import 'package:client_common/models/user_application_model.dart';
import 'package:client_common/navigator/common_navigator.dart';
import 'package:client_store/navigation/store_navigator.dart';
import 'package:flutter/material.dart';
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
    if (!isInitialized) return const CircularProgressIndicator();
    return Scaffold(
      backgroundColor: LenraColorThemeData.lenraWhite,
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
                            Navigator.of(context).pushNamed(CommonNavigator.profileRoute);
                          },
                          child: const Text("Profile"),
                        ),
                        InkWell(
                          onTap: () {
                            context.read<AuthModel>().logout().then((_) {
                              Navigator.of(context).pushNamed(StoreNavigator.homeRoute);
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
            spacing: 24,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: openedApps!.map((app) => ApplicationCard(app: app)).toList(),
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
    return InkWell(
      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () {
        Navigator.of(context).pushNamed("/app/${app.serviceName}");
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
            text: app.name,
          ),
        ],
      ),
    );
  }
}
