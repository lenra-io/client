import 'package:client_common/models/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class LogoutButton extends StatelessWidget {
  final logger = Logger('LogoutButton');

  LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.read<AuthModel>().logout().catchError((error) {
        logger.warning(error);
      }),
      child: const Text('Logout'),
    );
  }
}
