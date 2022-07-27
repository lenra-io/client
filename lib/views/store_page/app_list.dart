import 'package:client_common/models/store_model.dart';
import 'package:client_common/views/error.dart';
import 'package:client_store/navigation/store_navigator.dart';
import 'package:client_store/views/store_page/app_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppList extends StatelessWidget {
  const AppList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StoreModel storeModel = context.watch<StoreModel>();
    if (storeModel.fetchApplicationsStatus.hasError()) {
      return Error(storeModel.fetchApplicationsStatus.error!);
    }

    if (storeModel.fetchApplicationsStatus.isDone()) {
      return Wrap(
        children: storeModel.applications.map((appInfo) {
          return AppButton(
            appInfo: appInfo,
            onPressed: () {
              Navigator.of(context).pushNamed(StoreNavigator.buildAppRoute(appInfo.serviceName));
            },
          );
        }).toList(),
      );
    }

    return const CircularProgressIndicator();
  }
}
