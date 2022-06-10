import 'package:client_app/app.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App(accessToken: accessToken, appName: appName));
}

class Store extends StatelessWidget {
  const Store({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

}