import 'dart:typed_data';

import 'package:client_common/api/request_models/set_notify_provider_request.dart';
import 'package:client_common/api/user_api.dart';
import 'package:client_store/local_notif.dart';
import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:unifiedpush/unifiedpush.dart';

class AndroidNotif {
  static final List<void Function(String, String)> _onNewEndpointCallbacks = [];
  static final List<void Function(String)> _onUnregisteredCallbacks = [];
  static final List<void Function(String)> _onRegistrationFailedCallbacks = [];
  static final List<void Function(Uint8List, String)> _onMessageCallbacks = [];

  static init() async {
    // Configure Unified Push
    UnifiedPush.initialize(
      onNewEndpoint: onNewEndpoint, // takes (String endpoint, String instance) in args
      onRegistrationFailed: onRegistrationFailed, // takes (String instance)
      onUnregistered: onUnregistered, // takes (String instance)
      onMessage: onMessage, // takes (Uint8List message, String instance) in args
    );
  }

  static void onRegistrationFailed(String instance) {
    debugPrint("Call onRegistrationFailed callbacks");

    for (var cb in _onRegistrationFailedCallbacks) {
      cb(instance);
    }
  }

  static void onMessage(Uint8List u8message, String instance) async {
    debugPrint("Call onMessage callbacks");

    LocalNotif.showNotif(u8message);
    for (var cb in _onMessageCallbacks) {
      cb(u8message, instance);
    }
  }

  static void onNewEndpoint(String endpoint, String instance) async {
    debugPrint("Call onNewEndpointCallbacks callbacks");

    String? deviceId = await PlatformDeviceId.getDeviceId;

    if (deviceId != null) {
      UserApi.setNotifyProvider(deviceId, SetNotifyProviderRequest("unified_push", endpoint));
    }

    for (var cb in _onNewEndpointCallbacks) {
      debugPrint("Call $cb");
      cb(endpoint, instance);
    }
  }

  static void onUnregistered(String instance) {
    debugPrint("Call onUnregistered callbacks");

    for (var cb in _onUnregisteredCallbacks) {
      cb(instance);
    }
  }

  static void Function(String, String) addOnNewEndpointCallback(void Function(String, String) cb) {
    _onNewEndpointCallbacks.add(cb);
    return cb;
  }

  static removeOnNewEndpointCallback(void Function(String, String) cb) {
    _onNewEndpointCallbacks.remove(cb);
  }

  static void Function(Uint8List, String) addOnMessageCallback(void Function(Uint8List, String) cb) {
    _onMessageCallbacks.add(cb);
    return cb;
  }

  static removeOnMessageCallback(void Function(Uint8List, String) cb) {
    _onMessageCallbacks.remove(cb);
  }

  static void Function(String) addOnUnregisteredCallbacks(void Function(String) cb) {
    _onUnregisteredCallbacks.add(cb);
    return cb;
  }

  static removeOnUnregisteredCallbacks(void Function(String) cb) {
    _onUnregisteredCallbacks.remove(cb);
  }

  static void Function(String) addOnRegistrationFailedCallbacks(void Function(String) cb) {
    _onRegistrationFailedCallbacks.add(cb);
    return cb;
  }

  static removeOnRegistrationFailedCallbacks(void Function(String) cb) {
    _onRegistrationFailedCallbacks.remove(cb);
  }

  static registerApp(BuildContext context) {
    // Call the library function
    UnifiedPush.registerAppWithDialog(
      context,
      // instance,                        // Optionnal String, to get multiple endpoints (one per instance)
      // [featureAndroidBytesMessage]     // Optionnal String Array with required features
    );
  }

  static reregisterApp(BuildContext context) {
    unregisterApp();
    registerApp(context);
  }

  static unregisterApp() {
    UnifiedPush.unregister();
  }
}
