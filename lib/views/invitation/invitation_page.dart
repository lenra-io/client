import 'package:client/navigation/store_navigator.dart';
import 'package:client_common/models/user_application_model.dart';
import 'package:client_common/navigator/common_navigator.dart';
import 'package:client_common/views/simple_page.dart';
import 'package:flutter/material.dart';
import 'package:lenra_components/component/lenra_text.dart';
import 'package:lenra_components/layout/lenra_flex.dart';
import 'package:provider/provider.dart';

class InvitationPage extends StatelessWidget {
  final String invitationUuid;

  const InvitationPage({Key? key, required this.invitationUuid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserApplicationModel userApplicationModel = context.read<UserApplicationModel>();

    userApplicationModel
        .acceptInvitation(invitationUuid)
        .then((value) => {CommonNavigator.goPath(context, StoreNavigator.buildAppRoute(value.appName))});

    return const SimplePage(
      child: LenraFlex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          LenraText(text: "You are being redirected to the application, please wait."),
          LenraText(text: "If an error occurs please try again later."),
        ],
      ),
    );
  }
}
