import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initializes the notification service.
  static Future<void> initialize() async {
    // Initialize time zones
    tz.initializeTimeZones();

    // Set up initialization settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Combine initialization settings for all platforms
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Initialize the plugin
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        // Handle notification taps here if needed
      },
    );
  }

  /// Schedules a notification for a specific date and time.
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final now = DateTime.now();

    // Ensure the scheduled time is in the future
    if (scheduledTime.isBefore(now)) {
      if (kDebugMode) {
        print('Scheduled time is in the past. Notification will not be shown.');
      }
      return;
    }

    // Convert the scheduled time to a TZDateTime object
    final scheduledDateTimeZone = tz.TZDateTime.from(
      scheduledTime,
      tz.local, // Use the local time zone
    );

    // Define Android-specific notification details
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'Your Channel Name',
      importance: Importance.max, // High importance ensures delivery
      priority: Priority.high,    // High priority ensures visibility
      playSound: true,            // Play a sound to alert the user
    );

    // Combine platform-specific notification details
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Schedule the notification
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDateTimeZone,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Ensure exact timing
      matchDateTimeComponents: DateTimeComponents.time, // Match only the time component
    );
  }
}