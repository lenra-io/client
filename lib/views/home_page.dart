import 'package:client_common/api/response_models/app_response.dart';
import 'package:client_common/models/user_application_model.dart';
import 'package:client_common/views/simple_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isInitialized = false;
  List<AppResponse>? apps;

  @override
  void initState() {
    context.read<UserApplicationModel>().getAppsUserOpened().then((value) {
      setState(() {
        apps = value;
        isInitialized = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: "Lenra is under development",
      child: Text(
        "To access an application you must have its link provided by its creator.",
        textAlign: TextAlign.center,
      ),
    );
  }
}
