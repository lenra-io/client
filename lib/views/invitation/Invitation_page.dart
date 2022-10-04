import 'package:client_common/models/user_application_model.dart';
import 'package:client_common/views/simple_page.dart';
import 'package:client_store/navigation/store_navigator.dart';
import 'package:flutter/material.dart';
import 'package:lenra_components/component/lenra_text.dart';
import 'package:lenra_components/layout/lenra_flex.dart';
import 'package:provider/provider.dart';

class InvitationPage extends StatelessWidget {
  final String invitation_uuid;

  const InvitationPage({Key? key, required this.invitation_uuid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserApplicationModel userApplicationModel = context.read<UserApplicationModel>();

    userApplicationModel
        .acceptInvitation(invitation_uuid)
        .then((value) => {Navigator.of(context).pushReplacementNamed(StoreNavigator.buildAppRoute(value.appName))});

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
