import 'package:client_common/api/response_models/app_response.dart';
import 'package:client_common/models/user_application_model.dart';
import 'package:client_common/views/simple_page.dart';
import 'package:flutter/material.dart';
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
    return SimplePage(
      title: "Lenra is under development",
      child: LenraFlex(
        children: openedApps!.map((app) => ApplicationCard(app: app)).toList(),
      ),
    );
  }
}

class ApplicationCard extends StatelessWidget {
  final AppResponse app;

  ApplicationCard({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    var themeData = LenraThemeData();
    return LenraFlex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          color: app.color,
          child: LenraText(
            style: themeData.lenraTextThemeData.headline1,
            text: app.name[0].toUpperCase(),
          ),
        ),
        LenraText(text: app.name),
      ],
    );
  }
}
