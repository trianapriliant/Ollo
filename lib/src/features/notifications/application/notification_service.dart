import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../bills/domain/bill.dart';
import '../utils/timezone_helper.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap
      },
    );
  }

  Future<void> requestPermissions() async {
    // Android 13+
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // iOS
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'daily_reminder_channel',
      'Daily Reminders',
      channelDescription: 'Daily reminders to keep you on track',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      TimezoneHelper.nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel',
          'Daily Reminders',
          channelDescription: 'Daily reminders to keep you on track',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleBillReminders(Bill bill) async {
    if (bill.reminderOffsets == null || bill.reminderOffsets!.isEmpty) {
      await cancelBillReminders(bill.id);
      return;
    }

    // Cancel existing reminders for this bill
    await cancelBillReminders(bill.id);

    final dueDate = bill.dueDate;
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: 'Rp ', decimalDigits: 0);

    for (final offsetMinutes in bill.reminderOffsets!) {
      // Calculate notification time
      // If offset is 0, notify at 9:00 AM on due date
      // If offset > 0 (e.g. 1440 = 1 day), notify at 9:00 AM on (dueDate - 1 day)
      
      // Base date is the due date
      DateTime scheduledTime = dueDate;
      
      // Subtract the offset 
      scheduledTime = dueDate.subtract(Duration(minutes: offsetMinutes));
      
      // Force time to 9:00 AM for consistency (unless we want exact time logic later)
      scheduledTime = DateTime(scheduledTime.year, scheduledTime.month, scheduledTime.day, 9, 0, 0);

      if (scheduledTime.isBefore(DateTime.now())) {
        continue; // Skip past times
      }

      // Unique ID generation strategy:
      // Bill ID * 100 + index (allows up to 100 reminders per bill)
      final notificationId = bill.id * 100 + bill.reminderOffsets!.indexOf(offsetMinutes);

      String body = 'Your bill "${bill.title}" of ${currencyFormat.format(bill.amount)} is due on ${DateFormat('EEE, d MMM').format(dueDate)}.';
      if (offsetMinutes == 0) {
        body = 'Your bill "${bill.title}" is due TODAY! Amount: ${currencyFormat.format(bill.amount)}';
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        'Bill Reminder: ${bill.title}',
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'bill_reminders_channel',
            'Bill Reminders',
            channelDescription: 'Reminders for upcoming bills',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<void> scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    var now = tz.TZDateTime.now(tz.local);
    var nextSunday = now;
    while (nextSunday.weekday != DateTime.sunday) {
      nextSunday = nextSunday.add(const Duration(days: 1));
    }
    nextSunday = tz.TZDateTime(tz.local, nextSunday.year, nextSunday.month, nextSunday.day, hour, minute);
    if (nextSunday.isBefore(now)) {
      nextSunday = nextSunday.add(const Duration(days: 7));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      nextSunday,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'periodic_evaluation_channel',
          'Periodic Evaluations',
          channelDescription: 'Weekly and Monthly evaluation reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> scheduleMonthlyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    var now = tz.TZDateTime.now(tz.local);
    var nextDate = tz.TZDateTime(tz.local, now.year, now.month, 28, hour, minute);

    if (nextDate.isBefore(now)) {
      nextDate = tz.TZDateTime(tz.local, now.year, now.month + 1, 28, hour, minute);
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      nextDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'periodic_evaluation_channel',
          'Periodic Evaluations',
          channelDescription: 'Weekly and Monthly evaluation reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }

  Future<void> cancelBillReminders(int billId) async {
    // Cancel potential IDs (assuming max 10 reminders)
    for (int i = 0; i < 10; i++) {
        await flutterLocalNotificationsPlugin.cancel(billId * 100 + i);
    }
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
