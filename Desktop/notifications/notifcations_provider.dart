import 'dart:developer';

import 'package:fitness_with_dina/models/response_model/notification_response.dart';
import 'package:fitness_with_dina/repository/notification/notifications_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/network_status_service.dart';

class NotificationsProvider with ChangeNotifier {
  final NotifcationsRepository _notifcationsRepository =
      NotifcationsRepository();
  NotificationResponse? notificationResponse;
  bool loading = false;
  int count = 0;
  String notificationFilter = "All";

  startMonitoring(BuildContext context) {
    Provider.of<NetworkStatusServiceProvider>(context, listen: false)
        .startMonitoring();
  }

  Future getAllNotifcations({BuildContext? context}) async {
    try {
      notificationResponse =
          await _notifcationsRepository.getAllNotifications(context);
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }
}
