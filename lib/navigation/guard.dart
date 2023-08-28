import 'dart:async';

import 'package:client/navigation/store_navigator.dart';
import 'package:client/views/oauth_page.dart';
import 'package:client_common/navigator/guard.dart';
import 'package:flutter/material.dart';

typedef IsValid = Future<bool> Function(BuildContext, Map<String, dynamic>?);

class ClientGuard extends Guard {
  ClientGuard({required super.isValid, required super.onInvalid});

  static final Guard checkIsAuthenticated = Guard(isValid: isAuthenticated, onInvalid: toOauth);

  static Future<bool> isAuthenticated(BuildContext context) async {
    return OAuthPageState.isAuthenticated(context);
  }

  static String toOauth(context) {
    return StoreNavigator.oauth.path;
  }
}
