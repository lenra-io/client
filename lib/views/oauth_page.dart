// ignore_for_file: use_build_context_synchronously

import 'package:client_common/api/application_api.dart';
import 'package:client_common/api/lenra_http_client.dart';
import 'package:client_common/api/response_models/app_response.dart';
import 'package:client_common/api/response_models/user_response.dart';
import 'package:client_common/api/user_api.dart';
import 'package:client_common/models/auth_model.dart';
import 'package:client_common/oauth/oauth_model.dart';
import 'package:client_common/views/simple_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lenra_components/component/lenra_text.dart';
import 'package:lenra_components/lenra_components.dart';
import 'package:logging/logging.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OAuthPage extends StatefulWidget {
  const OAuthPage({super.key});

  @override
  State<OAuthPage> createState() => OAuthPageState();
}

class OAuthPageState extends State<OAuthPage> {
  final logger = Logger('AuthPage');

  var themeData = LenraThemeData();

  String? redirectTo;
  String? appServiceName;

  @override
  Widget build(BuildContext context) {
    redirectTo = context.read<OAuthModel>().beforeRedirectPath;
    RegExp regExp = RegExp(r"\/app\/([a-fA-F0-9-]{36})");
    final match = regExp.firstMatch(redirectTo ?? "/");
    appServiceName = match?.group(1);

    return FutureBuilder<bool>(
      future: isAuthenticated(context),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        }

        if (snapshot.hasData) {
          return SimplePage(
            header: appServiceName != null ? appHeader() : null,
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LenraButton(
                  onPressed: () async {
                    bool authenticated = await authenticate(context);
                    if (authenticated) {
                      context.go(context.read<OAuthModel>().beforeRedirectPath);
                    }
                  },
                  text: 'Log in with Lenra',
                )
              ],
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget? appHeader() {
    if (appServiceName == null) {
      return null;
    }

    return FutureBuilder<AppResponse>(
        future: ApplicationApi.getAppByServiceName(appServiceName!),
        builder: (context, snapshot) {
          return LenraFlex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 32,
            children: [
              Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color.fromARGB(255, 187, 234, 255),
                ),
                child: LenraText(
                  text: snapshot.data?.name[0].toUpperCase() ?? "A",
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: LenraColorThemeData.lenraBlue,
                    height: 100 / 80,
                  ),
                ),
              ),
              LenraFlex(
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LenraText(
                    text: snapshot.data?.name ?? "App",
                    style: themeData.lenraTextThemeData.headline1,
                  ),
                  LenraFlex(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const LenraText(text: "by"),
                      Image.asset(
                        "assets/images/logo-horizontal-black.png",
                        scale: 1.25,
                      ),
                      IconButton(
                        onPressed: () async {
                          final Uri url = Uri.parse('https://lenra.io');
                          if (!await launchUrl(url)) {
                            throw Exception('Could not launch $url');
                          }
                        },
                        icon: const Icon(Icons.info_outline),
                      ),
                    ],
                  ),
                ],
              )
            ],
          );
        });
  }

  static Future<bool> isAuthenticated(BuildContext context) async {
    OAuthModel oauthModel = context.read<OAuthModel>();

    AccessTokenResponse? token = await oauthModel.helper.getTokenFromStorage();
    if (token?.accessToken != null) {
      return await authenticate(context);
    }

    return oauthModel.accessToken != null;
  }

  static Future<bool> authenticate(BuildContext context) async {
    AccessTokenResponse? response = await context.read<OAuthModel>().authenticate();
    if (response != null) {
      context.read<AuthModel>().accessToken = response;

      // Set the token for the global API instance
      LenraApi.instance.token = response.accessToken;

      if (context.read<AuthModel>().user == null) {
        UserResponse user = await UserApi.me();
        context.read<AuthModel>().user = user.user;
      }

      return true;
    }

    return false;
  }
}
