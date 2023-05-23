import 'package:client_common/api/response_models/app_response.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final AppResponse appInfo;
  final VoidCallback onPressed;

  const AppButton({
    Key? key,
    required this.appInfo,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          color: appInfo.color,
          child: InkWell(
            onTap: onPressed,
            child: Container(
              width: 120,
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Icon(
                        appInfo.icon,
                        size: 64,
                      ),
                    ),
                    Text(appInfo.name!)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
