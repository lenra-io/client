import 'package:client_common/config/config.dart';
import 'package:client_common/models/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:lenra_ui_runner/app.dart';
import 'package:lenra_ui_runner/models/app_socket_model.dart';
import 'package:lenra_ui_runner/models/socket_model.dart';
import 'package:provider/provider.dart';

class AppPage extends StatelessWidget {
  final String appName;

  const AppPage({required this.appName, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<AuthModel, SocketModel>(
          create: (context) => AppSocketModel(context.read<AuthModel>().accessToken ?? "", appName),
          update: (_, authModel, socketModel) {
            if (socketModel == null) {
              return AppSocketModel(authModel.accessToken ?? "", appName);
            }

            (socketModel as AppSocketModel).update(authModel.accessToken ?? "");
            return socketModel;
          },
        ),
      ],
      builder: (BuildContext context, _) => App(
        appName: appName,
        accessToken: context.watch<AuthModel>().accessToken ?? "",
        httpEndpoint: Config.instance.httpEndpoint,
      ),
    );
  }
}
