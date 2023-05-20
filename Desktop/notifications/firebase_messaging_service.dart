import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/payments_and_subscription/subscription/subscription_plan.dart';
import '../../utils/strings.dart';
import 'notification_service.dart';

class FirebaseMessagingService {
  final NotificationService _notificationService;

  FirebaseMessagingService(this._notificationService);

  Future<void> initialize() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );
    getDeviceFirebaseToken();
    _onMessage();
    _onMessageOpenedApp();
  }

  getDeviceFirebaseToken() async {
    log("we here here for token");
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      log('This is Notification Token: ' '${token}');
      if (token != null) {
        final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
        final SharedPreferences pref = await prefs;
        pref.setString("fcmToken", token);
        log('TOKEN>>>>: $token');
      }
    } catch (e) {
      log("we got an exception ${e.toString()}");
      getDeviceFirebaseToken();
    }
    // if (Platform.isAndroid) {
    //   token = await FirebaseMessaging.instance.getToken();
    //
    // }
    // if (Platform.isIOS) {
    //  // log("aaa: ${await FirebaseMessaging.instance.getAPNSToken()}");
    //
    //   FirebaseMessaging.instance.getToken().then((iosToken) async {
    //     if (iosToken != null) {
    //       final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    //
    //       final SharedPreferences pref = await prefs;
    //
    //       pref.setString("fcmToken", iosToken);
    //     }
    //     print('This is iosToken: ' '${iosToken}');
    //    // print('This is Token: ' '${token}');
    //   });
    // }
    // debugPrint('=======================================');

    // debugPrint('=======================================');
  }

  void goToSubscription() {
    log("we are here to check it out 3213");
    Navigator.of(Strings.navigatorKey.currentContext!, rootNavigator: true)
        .pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const SubscriptionPlan();
        },
      ),
      (_) => false,
    );
  }

  _onMessage() {
    log("<<<we are on message>>>");
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AndroidNotification? ios = message.notification?.android;
      log("we are here notification1<<<<<<<<<<<<${notification?.toMap()}>>>>>>>");
      log("we are here notification2<<<<<<<<<<<<${notification?.body}>>>>>>>");
      log("we are here notification3<<<<<<<<<<<<${notification}>>>>>>>");
      log("we are here android<<<<<<<<<<<<${android?.link}>>>>>>>");
      log("we are here ios<<<<<<<<<<<<$ios>>>>>>>");
      if (notification != null && android != null) {
        _notificationService.showLocalNotification(
          CustomNotification(
            id: android.hashCode,
            title: notification.title!,
            body: notification.body!,
            payload: message.data['route'] ?? '',
          ),
        );
      } else if (notification != null && ios != null) {
        log("we are here <<<<<<<<<<<<ios$ios>>>>>>>");
        log("we are here <<<<<<<<<<<<notification.title${notification.title!}>>>>>>>");

        _notificationService.showLocalNotification(
          CustomNotification(
            id: android.hashCode,
            title: notification.title!,
            body: notification.body!,
            payload: message.data['route'] ?? '',
          ),
        );
      }
      log("we are here to check it out");
      if (notification!.body!.contains("Approved")) {
        log("we are here to check it out 21");

        goToSubscription();
      }
    });
  }

  _onMessageOpenedApp() {
    log("just try");
    FirebaseMessaging.onMessageOpenedApp.listen(_goToPageAfterMessage);
  }

  _goToPageAfterMessage(message) {
    log("why not this");
    final String route = message.data['route'] ?? '';
    if (route.isNotEmpty) {
      // Routes.navigatorKey?.currentState?.pushNamed(route);
    }
  }
}
