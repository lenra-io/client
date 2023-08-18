import 'package:client_common/oauth/oauth_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class LogoutButton extends StatelessWidget {
  final logger = Logger('LogoutButton');

  LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await context.read<OAuthModel>().helper.disconnect();
        // ignore: use_build_context_synchronously
        context.go("/");
      },
      child: const Text('Logout'),
    );
  }
}
