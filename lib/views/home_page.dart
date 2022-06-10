import 'package:client_common/views/simple_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
