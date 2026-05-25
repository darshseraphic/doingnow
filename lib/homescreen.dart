import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:ui' show lerpDouble;
import 'package:url_launcher/url_launcher.dart';

class _IconOption {
  final IconData icon;
  final String label;
  const _IconOption(this.icon, this.label);
}

class _IconCategory {
  final String name;
  final List<_IconOption> icons;
  const _IconCategory(this.name, this.icons);
}

const IconData kDefaultHabitIcon = Icons.check_circle_outline;

const List<_IconCategory> kIconCategories = [
  _IconCategory('Tasks', [
    _IconOption(Icons.check_circle_outline, 'Check'),
    _IconOption(Icons.check_box_outlined, 'Todo'),
    _IconOption(Icons.checklist_outlined, 'Checklist'),
    _IconOption(Icons.task_outlined, 'Task'),
    _IconOption(Icons.task_alt_outlined, 'TaskAlt'),
    _IconOption(Icons.assignment_outlined, 'Assignment'),
    _IconOption(Icons.assignment_turned_in_outlined, 'Done'),
    _IconOption(Icons.playlist_add_check_outlined, 'Playlist'),
    _IconOption(Icons.fact_check_outlined, 'FactCheck'),
    _IconOption(Icons.rule_outlined, 'Rule'),
    _IconOption(Icons.pending_actions_outlined, 'Pending'),
    _IconOption(Icons.flag_outlined, 'Flag'),
    _IconOption(Icons.push_pin_outlined, 'Pin'),
    _IconOption(Icons.label_outline, 'Label'),
    _IconOption(Icons.priority_high_outlined, 'Priority'),
    _IconOption(Icons.done_outline_outlined, 'Check2'),
    _IconOption(Icons.done_all_outlined, 'CheckAll'),
    _IconOption(Icons.low_priority_outlined, 'LowPri'),
    _IconOption(Icons.outlined_flag_outlined, 'Flag2'),
    _IconOption(Icons.local_offer_outlined, 'Tag'),
  ]),
  _IconCategory('Notes', [
    _IconOption(Icons.note_outlined, 'Note'),
    _IconOption(Icons.notes_outlined, 'Notes'),
    _IconOption(Icons.edit_outlined, 'Edit'),
    _IconOption(Icons.edit_note_outlined, 'EditNote'),
    _IconOption(Icons.description_outlined, 'Doc'),
    _IconOption(Icons.article_outlined, 'Article'),
    _IconOption(Icons.auto_stories_outlined, 'Story'),
    _IconOption(Icons.book_outlined, 'Book'),
    _IconOption(Icons.menu_book_outlined, 'MenuBook'),
    _IconOption(Icons.library_books_outlined, 'Library'),
    _IconOption(Icons.bookmark_outline, 'Bookmark'),
    _IconOption(Icons.create_outlined, 'Create'),
    _IconOption(Icons.draw_outlined, 'Draw'),
    _IconOption(Icons.format_quote_outlined, 'Quote'),
    _IconOption(Icons.text_snippet_outlined, 'Snippet'),
    _IconOption(Icons.newspaper_outlined, 'News'),
    _IconOption(Icons.receipt_long_outlined, 'Receipt'),
    _IconOption(Icons.summarize_outlined, 'Summary'),
    _IconOption(Icons.content_paste_outlined, 'Paste'),
    _IconOption(Icons.bookmarks_outlined, 'Bookmarks'),
  ]),
  _IconCategory('Time', [
    _IconOption(Icons.calendar_today_outlined, 'Calendar'),
    _IconOption(Icons.calendar_month_outlined, 'Month'),
    _IconOption(Icons.date_range_outlined, 'DateRange'),
    _IconOption(Icons.event_outlined, 'Event'),
    _IconOption(Icons.event_note_outlined, 'EventNote'),
    _IconOption(Icons.schedule_outlined, 'Schedule'),
    _IconOption(Icons.alarm_outlined, 'Alarm'),
    _IconOption(Icons.alarm_on_outlined, 'AlarmOn'),
    _IconOption(Icons.access_time_outlined, 'Time'),
    _IconOption(Icons.timer_outlined, 'Timer'),
    _IconOption(Icons.timelapse_outlined, 'Timelapse'),
    _IconOption(Icons.hourglass_empty_outlined, 'Hourglass'),
    _IconOption(Icons.update_outlined, 'Update'),
    _IconOption(Icons.history_outlined, 'History'),
    _IconOption(Icons.restore_outlined, 'Restore'),
    _IconOption(Icons.av_timer_outlined, 'AvTimer'),
    _IconOption(Icons.watch_later_outlined, 'WatchLater'),
    _IconOption(Icons.night_shelter_outlined, 'Night'),
    _IconOption(Icons.wb_sunny_outlined, 'Sun'),
    _IconOption(Icons.bedtime_outlined, 'Moon'),
  ]),
  _IconCategory('Health', [
    _IconOption(Icons.fitness_center_outlined, 'Fitness'),
    _IconOption(Icons.sports_outlined, 'Sports'),
    _IconOption(Icons.sports_soccer_outlined, 'Soccer'),
    _IconOption(Icons.sports_basketball_outlined, 'Basketball'),
    _IconOption(Icons.sports_tennis_outlined, 'Tennis'),
    _IconOption(Icons.sports_gymnastics_outlined, 'Gymnastics'),
    _IconOption(Icons.directions_run_outlined, 'Run'),
    _IconOption(Icons.directions_bike_outlined, 'Bike'),
    _IconOption(Icons.self_improvement_outlined, 'Yoga'),
    _IconOption(Icons.spa_outlined, 'Spa'),
    _IconOption(Icons.local_hospital_outlined, 'Hospital'),
    _IconOption(Icons.medical_services_outlined, 'Medical'),
    _IconOption(Icons.medication_outlined, 'Medicine'),
    _IconOption(Icons.healing_outlined, 'Healing'),
    _IconOption(Icons.monitor_heart_outlined, 'Heart'),
    _IconOption(Icons.restaurant_outlined, 'Food'),
    _IconOption(Icons.local_dining_outlined, 'Dining'),
    _IconOption(Icons.lunch_dining_outlined, 'Lunch'),
    _IconOption(Icons.coffee_outlined, 'Coffee'),
    _IconOption(Icons.liquor_outlined, 'Drinks'),
  ]),
  _IconCategory('People', [
    _IconOption(Icons.person_outline, 'Person'),
    _IconOption(Icons.people_outline, 'People'),
    _IconOption(Icons.person_add_outlined, 'AddPerson'),
    _IconOption(Icons.group_outlined, 'Group'),
    _IconOption(Icons.groups_outlined, 'Groups'),
    _IconOption(Icons.supervisor_account_outlined, 'Manager'),
    _IconOption(Icons.account_circle_outlined, 'Account'),
    _IconOption(Icons.face_outlined, 'Face'),
    _IconOption(Icons.sentiment_satisfied_outlined, 'Happy'),
    _IconOption(Icons.handshake_outlined, 'Handshake'),
    _IconOption(Icons.volunteer_activism_outlined, 'Volunteer'),
    _IconOption(Icons.family_restroom_outlined, 'Family'),
    _IconOption(Icons.child_care_outlined, 'Child'),
    _IconOption(Icons.waving_hand_outlined, 'Wave'),
    _IconOption(Icons.psychology_outlined, 'Mind'),
    _IconOption(Icons.elderly_outlined, 'Elderly'),
    _IconOption(Icons.accessible_outlined, 'Accessible'),
    _IconOption(Icons.diversity_3_outlined, 'Diversity'),
    _IconOption(Icons.emoji_people_outlined, 'EmojiP'),
    _IconOption(Icons.diversity_1_outlined, 'Diversity2'),
  ]),
  _IconCategory('Work', [
    _IconOption(Icons.work_outline, 'Work'),
    _IconOption(Icons.business_outlined, 'Business'),
    _IconOption(Icons.business_center_outlined, 'BizCenter'),
    _IconOption(Icons.corporate_fare_outlined, 'Corporate'),
    _IconOption(Icons.apartment_outlined, 'Apartment'),
    _IconOption(Icons.meeting_room_outlined, 'Meeting'),
    _IconOption(Icons.cases_outlined, 'Cases'),
    _IconOption(Icons.badge_outlined, 'Badge'),
    _IconOption(Icons.insights_outlined, 'Insights'),
    _IconOption(Icons.bar_chart_outlined, 'Chart'),
    _IconOption(Icons.pie_chart_outline_outlined, 'PieChart'),
    _IconOption(Icons.show_chart_outlined, 'LineChart'),
    _IconOption(Icons.trending_up_outlined, 'TrendUp'),
    _IconOption(Icons.trending_down_outlined, 'TrendDown'),
    _IconOption(Icons.leaderboard_outlined, 'Leaderboard'),
    _IconOption(Icons.analytics_outlined, 'Analytics'),
    _IconOption(Icons.assessment_outlined, 'Assessment'),
    _IconOption(Icons.account_balance_outlined, 'Balance'),
    _IconOption(Icons.attach_money_outlined, 'Money'),
    _IconOption(Icons.card_membership_outlined, 'Card'),
  ]),
  _IconCategory('Education', [
    _IconOption(Icons.school_outlined, 'School'),
    _IconOption(Icons.science_outlined, 'Science'),
    _IconOption(Icons.calculate_outlined, 'Math'),
    _IconOption(Icons.biotech_outlined, 'Biotech'),
    _IconOption(Icons.psychology_alt_outlined, 'Psych'),
    _IconOption(Icons.architecture_outlined, 'Arch'),
    _IconOption(Icons.engineering_outlined, 'Engineer'),
    _IconOption(Icons.history_edu_outlined, 'HistoryEdu'),
    _IconOption(Icons.class_outlined, 'Class'),
    _IconOption(Icons.auto_graph_outlined, 'AutoGraph'),
    _IconOption(Icons.functions_outlined, 'Functions'),
    _IconOption(Icons.data_object_outlined, 'DataObject'),
    _IconOption(Icons.hub_outlined, 'Hub'),
    _IconOption(Icons.api_outlined, 'Api'),
    _IconOption(Icons.terminal_outlined, 'Terminal'),
    _IconOption(Icons.memory_outlined, 'Memory'),
    _IconOption(Icons.developer_board_outlined, 'DevBoard'),
    _IconOption(Icons.schema_outlined, 'Schema'),
    _IconOption(Icons.model_training_outlined, 'ModelTrain'),
    _IconOption(Icons.data_array_outlined, 'DataArray'),
  ]),
  _IconCategory('Travel', [
    _IconOption(Icons.travel_explore_outlined, 'Travel'),
    _IconOption(Icons.flight_outlined, 'Flight'),
    _IconOption(Icons.flight_takeoff_outlined, 'Takeoff'),
    _IconOption(Icons.directions_car_outlined, 'Car'),
    _IconOption(Icons.directions_transit_outlined, 'Transit'),
    _IconOption(Icons.directions_bus_outlined, 'Bus'),
    _IconOption(Icons.train_outlined, 'Train'),
    _IconOption(Icons.sailing_outlined, 'Sailing'),
    _IconOption(Icons.directions_boat_outlined, 'Boat'),
    _IconOption(Icons.hotel_outlined, 'Hotel'),
    _IconOption(Icons.home_outlined, 'Home'),
    _IconOption(Icons.cottage_outlined, 'Cottage'),
    _IconOption(Icons.house_outlined, 'House'),
    _IconOption(Icons.location_on_outlined, 'Location'),
    _IconOption(Icons.map_outlined, 'Map'),
    _IconOption(Icons.explore_outlined, 'Explore'),
    _IconOption(Icons.terrain_outlined, 'Terrain'),
    _IconOption(Icons.beach_access_outlined, 'Beach'),
    _IconOption(Icons.park_outlined, 'Park'),
    _IconOption(Icons.cabin_outlined, 'Cabin'),
  ]),
  _IconCategory('Finance', [
    _IconOption(Icons.savings_outlined, 'Savings'),
    _IconOption(Icons.account_balance_wallet_outlined, 'Wallet'),
    _IconOption(Icons.credit_card_outlined, 'Card2'),
    _IconOption(Icons.payments_outlined, 'Pay'),
    _IconOption(Icons.receipt_outlined, 'Receipt2'),
    _IconOption(Icons.request_quote_outlined, 'Invoice'),
    _IconOption(Icons.price_check_outlined, 'Price'),
    _IconOption(Icons.monetization_on_outlined, 'Coin'),
    _IconOption(Icons.currency_bitcoin_outlined, 'Bitcoin'),
    _IconOption(Icons.shopping_bag_outlined, 'ShopBag'),
    _IconOption(Icons.shopping_cart_outlined, 'Cart'),
    _IconOption(Icons.store_outlined, 'Store'),
    _IconOption(Icons.storefront_outlined, 'Storefront'),
    _IconOption(Icons.sell_outlined, 'Sell'),
    _IconOption(Icons.discount_outlined, 'Discount'),
    _IconOption(Icons.inventory_2_outlined, 'Inventory'),
    _IconOption(Icons.redeem_outlined, 'Gift'),
    _IconOption(Icons.card_giftcard_outlined, 'GiftCard'),
    _IconOption(Icons.loyalty_outlined, 'Loyalty'),
    _IconOption(Icons.attach_money_outlined, 'Money2'),
  ]),
  _IconCategory('Tech', [
    _IconOption(Icons.code_outlined, 'Code'),
    _IconOption(Icons.devices_outlined, 'Devices'),
    _IconOption(Icons.computer_outlined, 'Computer'),
    _IconOption(Icons.laptop_outlined, 'Laptop'),
    _IconOption(Icons.phone_android_outlined, 'Android'),
    _IconOption(Icons.phone_iphone_outlined, 'iPhone'),
    _IconOption(Icons.tablet_outlined, 'Tablet'),
    _IconOption(Icons.watch_outlined, 'Watch'),
    _IconOption(Icons.keyboard_outlined, 'Keyboard'),
    _IconOption(Icons.headphones_outlined, 'Headphones'),
    _IconOption(Icons.speaker_outlined, 'Speaker'),
    _IconOption(Icons.tv_outlined, 'TV'),
    _IconOption(Icons.router_outlined, 'Router'),
    _IconOption(Icons.wifi_outlined, 'WiFi'),
    _IconOption(Icons.bluetooth_outlined, 'Bluetooth'),
    _IconOption(Icons.storage_outlined, 'Storage'),
    _IconOption(Icons.cloud_outlined, 'Cloud'),
    _IconOption(Icons.cloud_download_outlined, 'CloudDL'),
    _IconOption(Icons.usb_outlined, 'USB'),
    _IconOption(Icons.mouse_outlined, 'Mouse'),
  ]),
  _IconCategory('Media', [
    _IconOption(Icons.brush_outlined, 'Art'),
    _IconOption(Icons.palette_outlined, 'Palette'),
    _IconOption(Icons.color_lens_outlined, 'ColorLens'),
    _IconOption(Icons.music_note_outlined, 'Music'),
    _IconOption(Icons.music_video_outlined, 'MusicVideo'),
    _IconOption(Icons.album_outlined, 'Album'),
    _IconOption(Icons.audiotrack_outlined, 'Audio'),
    _IconOption(Icons.mic_outlined, 'Mic'),
    _IconOption(Icons.camera_alt_outlined, 'Photo'),
    _IconOption(Icons.camera_outlined, 'Camera'),
    _IconOption(Icons.videocam_outlined, 'Video'),
    _IconOption(Icons.movie_outlined, 'Movie'),
    _IconOption(Icons.theaters_outlined, 'Theater'),
    _IconOption(Icons.image_outlined, 'Image'),
    _IconOption(Icons.photo_library_outlined, 'Gallery'),
    _IconOption(Icons.collections_outlined, 'Collections'),
    _IconOption(Icons.design_services_outlined, 'Design'),
    _IconOption(Icons.auto_awesome_outlined, 'Awesome'),
    _IconOption(Icons.slideshow_outlined, 'Slideshow'),
    _IconOption(Icons.photo_camera_outlined, 'PhotoCam'),
  ]),
  _IconCategory('Symbols', [
    _IconOption(Icons.star_outline, 'Star'),
    _IconOption(Icons.favorite_outline, 'Heart'),
    _IconOption(Icons.lightbulb_outline, 'Idea'),
    _IconOption(Icons.emoji_objects_outlined, 'Bulb'),
    _IconOption(Icons.rocket_launch_outlined, 'Rocket'),
    _IconOption(Icons.lock_outline, 'Lock'),
    _IconOption(Icons.lock_open_outlined, 'Unlock'),
    _IconOption(Icons.key_outlined, 'Key'),
    _IconOption(Icons.settings_outlined, 'Settings'),
    _IconOption(Icons.build_outlined, 'Tools'),
    _IconOption(Icons.construction_outlined, 'Construct'),
    _IconOption(Icons.folder_outlined, 'Folder'),
    _IconOption(Icons.folder_open_outlined, 'FolderOpen'),
    _IconOption(Icons.archive_outlined, 'Archive'),
    _IconOption(Icons.recycling_outlined, 'Recycle'),
    _IconOption(Icons.eco_outlined, 'Eco'),
    _IconOption(Icons.water_drop_outlined, 'Water'),
    _IconOption(Icons.local_fire_department_outlined, 'Fire'),
    _IconOption(Icons.bolt_outlined, 'Bolt'),
    _IconOption(Icons.cloud_queue_outlined, 'Cloud2'),
  ]),
];

IconData _iconFromCP(int cp) {
  for (final cat in kIconCategories) {
    for (final opt in cat.icons) {
      if (opt.icon.codePoint == cp) return opt.icon;
    }
  }
  return kDefaultHabitIcon;
}

// ═══════════════════════════════════════════════════════════
//  NOTIFICATION SERVICE
// ═══════════════════════════════════════════════════════════

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _channelId = 'habit_reminders';
  static const _androidDetails = AndroidNotificationDetails(
    _channelId, 'Habit Reminders',
    channelDescription: 'Daily habit reminders',
    importance: Importance.max,
    priority: Priority.max,
    enableVibration: true,
    playSound: true,
    showWhen: false,
  );
  static const _details = NotificationDetails(
    android: _androidDetails,
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  Future<void> init() async {
    if (_initialized) return;
    // Timezone BEFORE plugin init — scheduling depends on tz.local
    _initTimezone();
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (_) {},
    );
    if (Platform.isAndroid) {
      final ap = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await ap?.createNotificationChannel(const AndroidNotificationChannel(
        _channelId, 'Habit Reminders',
        description: 'Daily habit reminders',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      ));
    }
    _initialized = true;
  }

  // Uses platform timezone name (IANA) — far more reliable than scanning
  // all 600 zones by offset which picks wrong zone when multiple zones
  // share the same UTC offset (e.g. UTC+5:30 matches 3 zones).
  void _initTimezone() {
    try {
      final tzName = DateTime.now().timeZoneName;
      try {
        tz.setLocalLocation(tz.getLocation(tzName));
        return;
      } catch (_) {}
      final h = DateTime.now().timeZoneOffset.inHours;
      final sign = h >= 0 ? '-' : '+';
      try {
        tz.setLocalLocation(tz.getLocation('Etc/GMT$sign${h.abs()}'));
        return;
      } catch (_) {}
      tz.setLocalLocation(tz.UTC);
    } catch (_) {}
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      final ap = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await ap?.requestNotificationsPermission();
      try { await ap?.requestExactAlarmsPermission(); } catch (_) {}
    } else if (Platform.isIOS) {
      final ip = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      await ip?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  // Opens Android battery optimization settings for this specific app.
  // Uses the standard ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS Intent URI
  // which directly opens the exemption dialog for this package.
  Future<void> requestBatteryOptimizationAccess() async {
    if (!Platform.isAndroid) return;
    // Intent URI format — the only reliable way to open Android settings
    // from Flutter/url_launcher. The 'action' in the Intent URI must match
    // Android's action string exactly.
    //
    // This opens: Settings > Battery > App > doingnow > No restrictions
    const packageId = 'com.example.doingnow';
    final uri = Uri.parse(
      'intent:#Intent;'
          'action=android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS;'
          'data=package:$packageId;'
          'end',
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Fallback: open app details page where user can find battery settings
      try {
        await launchUrl(
          Uri.parse(
            'intent:#Intent;'
                'action=android.settings.APPLICATION_DETAILS_SETTINGS;'
                'data=package:$packageId;'
                'end',
          ),
          mode: LaunchMode.externalApplication,
        );
      } catch (_) {}
    }
  }

  // Collision-free ID: each habit gets 10 unique slots (one per weekday 0-6)
  int _id(String habitId, int weekday) {
    final base = (int.tryParse(habitId) ?? habitId.hashCode.abs()) % 100000000;
    return base * 10 + weekday;
  }

  Future<void> scheduleHabit(Habit habit) async {
    if (!_initialized) return;
    await cancelHabit(habit.id);
    if (!habit.notificationEnabled || habit.archived) return;

    final days = habit.reminder.days.isEmpty
        ? List.generate(7, (i) => i)
        : habit.reminder.days.toList();

    for (final weekday in days) {
      final id = _id(habit.id, weekday);
      final fireAt = _nextWeekday(weekday, habit.reminder.time);
      final body = 'Time to complete the ${habit.title} habit';

      // alarmClock = AlarmManager.setAlarmClock()
      // This is the SAME API used by Google Clock, Samsung Clock, and every
      // calendar/reminder app. Android guarantees delivery even when app is
      // killed — OEMs cannot cancel it without breaking their own clock apps.
      try {
        await _plugin.zonedSchedule(
          id, 'doingnow', body, fireAt, _details,
          androidScheduleMode: AndroidScheduleMode.alarmClock,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      } catch (e) {
        // Fallback: exactAllowWhileIdle (less reliable on aggressive OEMs)
        try {
          await _plugin.zonedSchedule(
            id, 'doingnow', body, fireAt, _details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          );
        } catch (e2) {
          debugPrint('[NS] schedule failed: $e2');
        }
      }
    }
  }

  Future<void> cancelHabit(String habitId) async {
    for (int wd = 0; wd < 7; wd++) {
      await _plugin.cancel(_id(habitId, wd));
    }
  }

  Future<void> cancelAll() => _plugin.cancelAll();

  Future<void> rescheduleAll(List<Habit> habits) async {
    if (!_initialized) return;
    for (final h in habits) {
      if (h.notificationEnabled && !h.archived) await scheduleHabit(h);
      else await cancelHabit(h.id);
    }
  }

  tz.TZDateTime _nextWeekday(int weekday, TimeOfDay time) {
    final dartWeekday = weekday + 1; // Dart: Mon=1..Sun=7
    final now = tz.TZDateTime.now(tz.local);
    var candidate = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, time.hour, time.minute,
    );
    for (int i = 0; i < 14; i++) {
      if (candidate.weekday == dartWeekday && candidate.isAfter(now)) {
        return candidate;
      }
      candidate = candidate.add(const Duration(days: 1));
    }
    return now.add(const Duration(days: 7));
  }

}
// ═══════════════════════════════════════════════════════════
//  HOME SCREEN WIDGET UPDATER
//  Uses home_widget package. Add to pubspec:
//    home_widget: ^0.7.0
//  And follow setup at pub.dev/packages/home_widget
// ═══════════════════════════════════════════════════════════

class HomeWidgetUpdater {
  HomeWidgetUpdater._();
  static final HomeWidgetUpdater instance = HomeWidgetUpdater._();

  // Call this whenever habit data changes to update the home screen widget
  Future<void> updateWidget(List<Habit> habits) async {
    // This is a no-op if home_widget is not set up —
    // wire in home_widget package calls here once you add it.
    // Example with home_widget package:
    //
    // import 'package:home_widget/home_widget.dart';
    //
    // final today = DateTime.now();
    // final todayHabits = habits.where((h) =>
    //     h.isScheduledOn(today) && !h.archived).toList();
    // final completed = todayHabits.where((h) => h.isCompletedOn(today)).length;
    // final total = todayHabits.length;
    //
    // await HomeWidget.saveWidgetData<String>(
    //   'habits_summary',
    //   '$completed/$total habits done today',
    // );
    // await HomeWidget.saveWidgetData<String>(
    //   'habit_list',
    //   todayHabits.map((h) =>
    //     '${h.isCompletedOn(today) ? '✓' : '○'} ${h.title}').join('\n'),
    // );
    // await HomeWidget.updateWidget(
    //   name: 'HabitWidgetProvider',  // Android AppWidgetProvider class name
    //   iOSName: 'HabitWidget',       // iOS widget name
    // );
  }
}

// ═══════════════════════════════════════════════════════════
//  THEME
// ═══════════════════════════════════════════════════════════

enum AppThemeModePreference { light, dark }

class AppLanguage {
  final String code;
  final String name;
  final String flag;
  const AppLanguage({
    required this.code,
    required this.name,
    required this.flag,
  });
}

const List<AppLanguage> kAppLanguages = [
  AppLanguage(code: 'en', name: 'English', flag: '🇺🇸'),
  AppLanguage(code: 'de', name: 'Deutsch', flag: '🇩🇪'),
  AppLanguage(code: 'fr', name: 'Français', flag: '🇫🇷'),
  AppLanguage(code: 'es', name: 'Español', flag: '🇪🇸'),
  AppLanguage(code: 'it', name: 'Italiano', flag: '🇮🇹'),
  AppLanguage(code: 'pt', name: 'Português', flag: '🇧🇷'),
  AppLanguage(code: 'hu', name: 'Magyar', flag: '🇭🇺'),
  AppLanguage(code: 'ro', name: 'Română', flag: '🇷🇴'),
  AppLanguage(code: 'tr', name: 'Türkçe', flag: '🇹🇷'),
  AppLanguage(code: 'ru', name: 'Русский', flag: '🇷🇺'),
  AppLanguage(code: 'uk', name: 'Українська', flag: '🇺🇦'),
  AppLanguage(code: 'zh', name: '简体中文', flag: '🇨🇳'),
  AppLanguage(code: 'ja', name: '日本語', flag: '🇯🇵'),
  AppLanguage(code: 'ko', name: '한국어', flag: '🇰🇷'),
  AppLanguage(code: 'vi', name: 'Tiếng Việt', flag: '🇻🇳'),
  AppLanguage(code: 'ar', name: 'العربية', flag: '🇸🇦'),
  AppLanguage(code: 'id', name: 'Indonesia', flag: '🇮🇩'),
  AppLanguage(code: 'th', name: 'ภาษาไทย', flag: '🇹🇭'),
  AppLanguage(code: 'hi', name: 'हिन्दी', flag: '🇮🇳'),
  AppLanguage(code: 'nl', name: 'Nederlands', flag: '🇳🇱'),
  AppLanguage(code: 'pl', name: 'Polski', flag: '🇵🇱'),
  AppLanguage(code: 'sv', name: 'Svenska', flag: '🇸🇪'),
];

class AppStrings {
  static const Map<String, String> _en = {
    'month': 'Month',
    'week': 'Week',
    'year': 'Year',
    'statistics': 'Statistics',
    'settings': 'Settings',
    'noHabitsYet': 'No habits yet.',
    'tapPlusCreate': 'Tap + to create one.',
    'theme': 'Theme',
    'language': 'Language',
    'archive': 'Archive',
    'privacyPolicy': 'Privacy policy',
    'defaultTheme': 'Default',
    'light': 'Light',
    'dark': 'Dark',
    'complete': 'Complete',
    'calendar': 'Calendar',
    'notes': 'Notes',
    'edit': 'Edit',
    'share': 'Share',
    'saveNote': 'Save Note',
    'writeNote': 'Write your note...',
    'noteForDay': 'Note',
    'createHabit': 'Create Habit',
    'editHabit': 'Edit Habit',
    'title': 'Title',
    'description': 'Description',
    'pickIcon': 'Pick Icon',
    'category': 'Category',
    'completionsPerDay': 'Completions per day',
    'reminder': 'Reminder',
    'pickTime': 'Pick a time',
    'showStreak': 'Show streak',
    'daily': 'Daily',
    'weekly': 'Weekly',
    'save': 'Save',
    'update': 'Update',
    'completedDays': 'Completed days',
    'completionRate': 'Completion rate',
    'notifications': 'Notifications',
    'notificationsDescription': 'Get reminded for habits you select.',
    'enableNotification': 'Enable notification for this habit',
    'monthlyCompletions': 'Monthly completions',
    'currentDailyStreak': 'Current daily streak',
    'bestDailyStreak': 'Best daily streak',
    'currentWeeklyStreak': 'Current weekly streak',
    'bestWeeklyStreak': 'Best weekly streak',
    'shareProgress': 'Share',
    'copyText': 'Copy text',
    'close': 'Close',
    'copied': 'Copied',
    'todayComplete': 'Today complete',
    'notCompleted': 'Not completed',
    'scheduledToday': 'Scheduled today',
    'notScheduledToday': 'Not scheduled today',
    'restore': 'Restore',
    'delete': 'Delete',
    'deleteProgressTitle': 'You want to Delete you progress?',
    'cancel': 'Cancel',
    'noArchivedHabits': 'No archived habits yet.',
    'privacyText': "Your data stays on your device and isn't shared. Feel free to write about your thoughts, daily life, and experiences - darshseraphic",
    'versionClean': 'version - v0.1.0 - Beta',
    'shareSummary': 'Progress summary',
    'themeDescription': 'Choose how the app looks.',
    'languageDescription': 'Pick the app language.',
    'archiveDescription': 'Restore or delete archived habits.',
    'privacyDescription': 'See how your data is handled.',
    'emptyArchiveHint': 'Archived habits will appear here.',
  };

  static final Map<String, Map<String, String>> _values = {
    'en': _en,
    'es': _merge(_en, {
      'month': 'Mes',
      'week': 'Semana',
      'year': 'Ano',
      'statistics': 'Estadisticas',
      'settings': 'Ajustes',
      'noHabitsYet': 'Aun no hay habitos.',
      'tapPlusCreate': 'Toca + para crear uno.',
      'theme': 'Tema',
      'language': 'Idioma',
      'archive': 'Archivo',
      'privacyPolicy': 'Politica de privacidad',
      'defaultTheme': 'Predeterminado',
      'light': 'Claro',
      'dark': 'Oscuro',
      'complete': 'Completar',
      'calendar': 'Calendario',
      'notes': 'Notas',
      'edit': 'Editar',
      'share': 'Compartir',
      'saveNote': 'Guardar nota',
      'writeNote': 'Escribe tu nota...',
      'noteForDay': 'Nota',
      'createHabit': 'Crear habito',
      'editHabit': 'Editar habito',
      'title': 'Titulo',
      'description': 'Descripcion',
      'pickIcon': 'Elegir icono',
      'category': 'Categoria',
      'completionsPerDay': 'Completados por dia',
      'reminder': 'Recordatorio',
      'pickTime': 'Elegir hora',
      'showStreak': 'Mostrar racha',
      'daily': 'Diaria',
      'weekly': 'Semanal',
      'save': 'Guardar',
      'update': 'Actualizar',
      'completedDays': 'Dias completados',
      'completionRate': 'Tasa de finalizacion',
      'monthlyCompletions': 'Completados mensuales',
      'currentDailyStreak': 'Racha diaria actual',
      'bestDailyStreak': 'Mejor racha diaria',
      'currentWeeklyStreak': 'Racha semanal actual',
      'bestWeeklyStreak': 'Mejor racha semanal',
      'copyText': 'Copiar texto',
      'close': 'Cerrar',
      'copied': 'Copiado',
      'todayComplete': 'Completado hoy',
      'notCompleted': 'Sin completar',
      'scheduledToday': 'Programado para hoy',
      'notScheduledToday': 'No programado hoy',
      'restore': 'Restaurar',
      'delete': 'Eliminar',
      'cancel': 'Cancelar',
      'noArchivedHabits': 'Todavia no hay habitos archivados.',
      'privacyText': 'Tus datos permanecen en tu dispositivo y no se comparten. Puedes escribir sobre tus pensamientos, tu vida diaria y tus experiencias - darshseraphic',
      'shareSummary': 'Resumen del progreso',
      'themeDescription': 'Elige el aspecto de la app.',
      'languageDescription': 'Elige el idioma de la app.',
      'archiveDescription': 'Restaura o elimina habitos archivados.',
      'privacyDescription': 'Mira como se gestionan tus datos.',
      'emptyArchiveHint': 'Los habitos archivados apareceran aqui.',
    }),
    'de': _merge(_en, {
      'month': 'Monat',
      'week': 'Woche',
      'year': 'Jahr',
      'statistics': 'Statistik',
      'settings': 'Einstellungen',
      'noHabitsYet': 'Noch keine Gewohnheiten.',
      'tapPlusCreate': 'Tippe auf +, um eine zu erstellen.',
      'theme': 'Thema',
      'language': 'Sprache',
      'archive': 'Archiv',
      'privacyPolicy': 'Datenschutz',
      'defaultTheme': 'Standard',
      'light': 'Hell',
      'dark': 'Dunkel',
      'complete': 'Erledigen',
      'calendar': 'Kalender',
      'notes': 'Notizen',
      'edit': 'Bearbeiten',
      'share': 'Teilen',
      'saveNote': 'Notiz speichern',
      'writeNote': 'Schreibe deine Notiz...',
      'noteForDay': 'Notiz',
      'createHabit': 'Gewohnheit erstellen',
      'editHabit': 'Gewohnheit bearbeiten',
      'title': 'Titel',
      'description': 'Beschreibung',
      'pickIcon': 'Symbol wahlen',
      'category': 'Kategorie',
      'completionsPerDay': 'Erledigungen pro Tag',
      'reminder': 'Erinnerung',
      'pickTime': 'Zeit wahlen',
      'showStreak': 'Serie anzeigen',
      'daily': 'Taglich',
      'weekly': 'Wochentlich',
      'save': 'Speichern',
      'update': 'Aktualisieren',
      'completedDays': 'Erledigte Tage',
      'completionRate': 'Erfullungsrate',
      'monthlyCompletions': 'Monatliche Erledigungen',
      'currentDailyStreak': 'Aktuelle Tagesserie',
      'bestDailyStreak': 'Beste Tagesserie',
      'currentWeeklyStreak': 'Aktuelle Wochenserie',
      'bestWeeklyStreak': 'Beste Wochenserie',
      'copyText': 'Text kopieren',
      'close': 'Schliessen',
      'copied': 'Kopiert',
      'todayComplete': 'Heute erledigt',
      'notCompleted': 'Nicht erledigt',
      'scheduledToday': 'Heute geplant',
      'notScheduledToday': 'Heute nicht geplant',
      'restore': 'Wiederherstellen',
      'delete': 'Loschen',
      'deleteProgressTitle': 'Willst du deinen Fortschritt loschen?',
      'cancel': 'Abbrechen',
      'noArchivedHabits': 'Noch keine archivierten Gewohnheiten.',
      'privacyText': 'Deine Daten bleiben auf deinem Geraet und werden nicht geteilt. Du kannst frei ueber deine Gedanken, dein taegliches Leben und deine Erfahrungen schreiben - darshseraphic',
      'shareSummary': 'Fortschrittsubersicht',
      'themeDescription': 'Wahle das Aussehen der App.',
      'languageDescription': 'Wahle die App-Sprache.',
      'archiveDescription': 'Archivierte Gewohnheiten wiederherstellen oder loschen.',
      'privacyDescription': 'Sieh, wie deine Daten behandelt werden.',
      'emptyArchiveHint': 'Archivierte Gewohnheiten erscheinen hier.',
    }),
    'fr': _merge(_en, {
      'month': 'Mois',
      'week': 'Semaine',
      'year': 'Annee',
      'statistics': 'Statistiques',
      'settings': 'Parametres',
      'noHabitsYet': 'Aucune habitude pour le moment.',
      'tapPlusCreate': 'Touchez + pour en creer une.',
      'theme': 'Theme',
      'language': 'Langue',
      'archive': 'Archive',
      'privacyPolicy': 'Politique de confidentialite',
      'defaultTheme': 'Par defaut',
      'light': 'Clair',
      'dark': 'Sombre',
      'complete': 'Terminer',
      'calendar': 'Calendrier',
      'notes': 'Notes',
      'edit': 'Modifier',
      'share': 'Partager',
      'saveNote': 'Enregistrer la note',
      'writeNote': 'Ecris ta note...',
      'noteForDay': 'Note',
      'createHabit': 'Creer une habitude',
      'editHabit': 'Modifier l habitude',
      'title': 'Titre',
      'description': 'Description',
      'pickIcon': 'Choisir une icone',
      'category': 'Categorie',
      'completionsPerDay': 'Actions par jour',
      'reminder': 'Rappel',
      'pickTime': 'Choisir l heure',
      'showStreak': 'Afficher la serie',
      'daily': 'Quotidien',
      'weekly': 'Hebdomadaire',
      'save': 'Enregistrer',
      'update': 'Mettre a jour',
      'completedDays': 'Jours completes',
      'completionRate': 'Taux de completion',
      'monthlyCompletions': 'Completions mensuelles',
      'currentDailyStreak': 'Serie quotidienne actuelle',
      'bestDailyStreak': 'Meilleure serie quotidienne',
      'currentWeeklyStreak': 'Serie hebdomadaire actuelle',
      'bestWeeklyStreak': 'Meilleure serie hebdomadaire',
      'copyText': 'Copier le texte',
      'close': 'Fermer',
      'copied': 'Copie',
      'todayComplete': 'Termine aujourd hui',
      'notCompleted': 'Non termine',
      'scheduledToday': 'Prevu aujourd hui',
      'notScheduledToday': 'Non prevu aujourd hui',
      'restore': 'Restaurer',
      'delete': 'Supprimer',
      'deleteProgressTitle': 'Voulez-vous supprimer votre progression ?',
      'cancel': 'Annuler',
      'noArchivedHabits': 'Aucune habitude archivee.',
      'privacyText': 'Tes donnees restent sur ton appareil et ne sont pas partagees. Tu peux ecrire librement sur tes pensees, ta vie quotidienne et tes experiences - darshseraphic',
      'shareSummary': 'Resume de progression',
      'themeDescription': 'Choisissez l apparence de l application.',
      'languageDescription': 'Choisissez la langue de l application.',
      'archiveDescription': 'Restaurer ou supprimer les habitudes archivees.',
      'privacyDescription': 'Voyez comment vos donnees sont gerees.',
      'emptyArchiveHint': 'Les habitudes archivees apparaitront ici.',
    }),
    'it': _merge(_en, {
      'month': 'Mese',
      'week': 'Settimana',
      'year': 'Anno',
      'statistics': 'Statistiche',
      'settings': 'Impostazioni',
      'noHabitsYet': 'Nessuna abitudine ancora.',
      'tapPlusCreate': 'Tocca + per crearne una.',
      'theme': 'Tema',
      'language': 'Lingua',
      'archive': 'Archivio',
      'privacyPolicy': 'Informativa sulla privacy',
      'defaultTheme': 'Predefinito',
      'light': 'Chiaro',
      'dark': 'Scuro',
      'complete': 'Completa',
      'calendar': 'Calendario',
      'notes': 'Note',
      'edit': 'Modifica',
      'share': 'Condividi',
      'saveNote': 'Salva nota',
      'writeNote': 'Scrivi la tua nota...',
      'noteForDay': 'Nota',
      'createHabit': 'Crea abitudine',
      'editHabit': 'Modifica abitudine',
      'title': 'Titolo',
      'description': 'Descrizione',
      'pickIcon': 'Scegli icona',
      'category': 'Categoria',
      'completionsPerDay': 'Completamenti al giorno',
      'reminder': 'Promemoria',
      'pickTime': 'Scegli orario',
      'showStreak': 'Mostra serie',
      'daily': 'Giornaliera',
      'weekly': 'Settimanale',
      'save': 'Salva',
      'update': 'Aggiorna',
      'completedDays': 'Giorni completati',
      'completionRate': 'Tasso di completamento',
      'monthlyCompletions': 'Completamenti mensili',
      'currentDailyStreak': 'Serie giornaliera attuale',
      'bestDailyStreak': 'Migliore serie giornaliera',
      'currentWeeklyStreak': 'Serie settimanale attuale',
      'bestWeeklyStreak': 'Migliore serie settimanale',
      'copyText': 'Copia testo',
      'close': 'Chiudi',
      'copied': 'Copiato',
      'todayComplete': 'Completato oggi',
      'notCompleted': 'Non completato',
      'scheduledToday': 'Previsto oggi',
      'notScheduledToday': 'Non previsto oggi',
      'restore': 'Ripristina',
      'delete': 'Elimina',
      'deleteProgressTitle': 'Vuoi eliminare i tuoi progressi?',
      'cancel': 'Annulla',
      'noArchivedHabits': 'Nessuna abitudine archiviata.',
      'privacyText': 'I tuoi dati restano sul tuo dispositivo e non vengono condivisi. Sentiti libero di scrivere pensieri, vita quotidiana ed esperienze - darshseraphic',
      'shareSummary': 'Riepilogo progressi',
      'themeDescription': 'Scegli l aspetto dell app.',
      'languageDescription': 'Scegli la lingua dell app.',
      'archiveDescription': 'Ripristina o elimina le abitudini archiviate.',
      'privacyDescription': 'Scopri come vengono gestiti i tuoi dati.',
      'emptyArchiveHint': 'Le abitudini archiviate appariranno qui.',
    }),
    'pt': _merge(_en, {
      'month': 'Mes',
      'week': 'Semana',
      'year': 'Ano',
      'statistics': 'Estatisticas',
      'settings': 'Configuracoes',
      'noHabitsYet': 'Ainda nao ha habitos.',
      'tapPlusCreate': 'Toque em + para criar um.',
      'theme': 'Tema',
      'language': 'Idioma',
      'archive': 'Arquivo',
      'privacyPolicy': 'Politica de privacidade',
      'defaultTheme': 'Padrao',
      'light': 'Claro',
      'dark': 'Escuro',
      'complete': 'Concluir',
      'calendar': 'Calendario',
      'notes': 'Notas',
      'edit': 'Editar',
      'share': 'Compartilhar',
      'saveNote': 'Salvar nota',
      'writeNote': 'Escreva sua nota...',
      'noteForDay': 'Nota',
      'createHabit': 'Criar habito',
      'editHabit': 'Editar habito',
      'title': 'Titulo',
      'description': 'Descricao',
      'pickIcon': 'Escolher icone',
      'category': 'Categoria',
      'completionsPerDay': 'Conclusoes por dia',
      'reminder': 'Lembrete',
      'pickTime': 'Escolher horario',
      'showStreak': 'Mostrar sequencia',
      'daily': 'Diario',
      'weekly': 'Semanal',
      'save': 'Salvar',
      'update': 'Atualizar',
      'completedDays': 'Dias concluidos',
      'completionRate': 'Taxa de conclusao',
      'monthlyCompletions': 'Conclusoes mensais',
      'currentDailyStreak': 'Sequencia diaria atual',
      'bestDailyStreak': 'Melhor sequencia diaria',
      'currentWeeklyStreak': 'Sequencia semanal atual',
      'bestWeeklyStreak': 'Melhor sequencia semanal',
      'copyText': 'Copiar texto',
      'close': 'Fechar',
      'copied': 'Copiado',
      'todayComplete': 'Concluido hoje',
      'notCompleted': 'Nao concluido',
      'scheduledToday': 'Programado para hoje',
      'notScheduledToday': 'Nao programado para hoje',
      'restore': 'Restaurar',
      'delete': 'Excluir',
      'deleteProgressTitle': 'Voce quer excluir seu progresso?',
      'cancel': 'Cancelar',
      'noArchivedHabits': 'Ainda nao ha habitos arquivados.',
      'privacyText': 'Seus dados ficam no seu dispositivo e nao sao compartilhados. Escreva livremente sobre pensamentos, vida diaria e experiencias - darshseraphic',
      'shareSummary': 'Resumo do progresso',
      'themeDescription': 'Escolha a aparencia do app.',
      'languageDescription': 'Escolha o idioma do app.',
      'archiveDescription': 'Restaure ou exclua habitos arquivados.',
      'privacyDescription': 'Veja como seus dados sao tratados.',
      'emptyArchiveHint': 'Habitos arquivados aparecerao aqui.',
    }),
    'hu': _merge(_en, {
      'month': 'Honap',
      'week': 'Het',
      'year': 'Ev',
      'statistics': 'Statisztika',
      'settings': 'Beallitasok',
      'theme': 'Tema',
      'language': 'Nyelv',
      'archive': 'Archivum',
      'privacyPolicy': 'Adatvedelem',
      'defaultTheme': 'Alapertelmezett',
      'light': 'Vilagos',
      'dark': 'Sotet',
      'complete': 'Teljesit',
      'calendar': 'Naptar',
      'notes': 'Jegyzetek',
      'edit': 'Szerkesztes',
      'share': 'Megosztas',
      'saveNote': 'Jegyzet mentese',
      'noteForDay': 'Jegyzet',
      'createHabit': 'Szokas letrehozasa',
      'editHabit': 'Szokas szerkesztese',
      'title': 'Cim',
      'description': 'Leiras',
      'pickIcon': 'Ikon valasztasa',
      'category': 'Kategoria',
      'completionsPerDay': 'Teljesites naponta',
      'reminder': 'Emlkezteto',
      'pickTime': 'Ido valasztasa',
      'showStreak': 'Sorozat mutatasa',
      'daily': 'Napi',
      'weekly': 'Heti',
      'save': 'Mentes',
      'update': 'Frissites',
      'completedDays': 'Teljesitett napok',
      'completionRate': 'Teljesitesi arany',
      'monthlyCompletions': 'Havi teljesitesek',
      'restore': 'Visszaallitas',
      'delete': 'Torles',
      'cancel': 'Megse',
      'noArchivedHabits': 'Meg nincsenek archivalt szokasok.',
      'shareSummary': 'Haladas osszegzes',
    }),
    'ro': _merge(_en, {
      'month': 'Luna',
      'week': 'Saptamana',
      'year': 'An',
      'statistics': 'Statistici',
      'settings': 'Setari',
      'theme': 'Tema',
      'language': 'Limba',
      'archive': 'Arhiva',
      'privacyPolicy': 'Politica de confidentialitate',
      'defaultTheme': 'Implicit',
      'light': 'Luminos',
      'dark': 'Intunecat',
      'complete': 'Completeaza',
      'calendar': 'Calendar',
      'notes': 'Note',
      'edit': 'Editeaza',
      'share': 'Distribuie',
      'saveNote': 'Salveaza nota',
      'noteForDay': 'Nota',
      'createHabit': 'Creeaza obicei',
      'editHabit': 'Editeaza obiceiul',
      'title': 'Titlu',
      'description': 'Descriere',
      'pickIcon': 'Alege iconita',
      'category': 'Categorie',
      'completionsPerDay': 'Completari pe zi',
      'reminder': 'Memento',
      'pickTime': 'Alege ora',
      'showStreak': 'Arata seria',
      'daily': 'Zilnic',
      'weekly': 'Saptamanal',
      'save': 'Salveaza',
      'update': 'Actualizeaza',
      'completedDays': 'Zile completate',
      'completionRate': 'Rata de completare',
      'monthlyCompletions': 'Completari lunare',
      'restore': 'Restaureaza',
      'delete': 'Sterge',
      'cancel': 'Anuleaza',
      'noArchivedHabits': 'Nu exista inca obiceiuri arhivate.',
      'shareSummary': 'Rezumat progres',
    }),
    'tr': _merge(_en, {
      'month': 'Ay',
      'week': 'Hafta',
      'year': 'Yil',
      'statistics': 'Istatistik',
      'settings': 'Ayarlar',
      'theme': 'Tema',
      'language': 'Dil',
      'archive': 'Arsiv',
      'privacyPolicy': 'Gizlilik politikasi',
      'defaultTheme': 'Varsayilan',
      'light': 'Acik',
      'dark': 'Koyu',
      'complete': 'Tamamla',
      'calendar': 'Takvim',
      'notes': 'Notlar',
      'edit': 'Duzenle',
      'share': 'Paylas',
      'saveNote': 'Notu kaydet',
      'noteForDay': 'Not',
      'createHabit': 'Aliskanlik olustur',
      'editHabit': 'Aliskanligi duzenle',
      'title': 'Baslik',
      'description': 'Aciklama',
      'pickIcon': 'Simge sec',
      'category': 'Kategori',
      'completionsPerDay': 'Gunluk tamamlama',
      'reminder': 'Hatirlatici',
      'pickTime': 'Saat sec',
      'showStreak': 'Seriyi goster',
      'daily': 'Gunluk',
      'weekly': 'Haftalik',
      'save': 'Kaydet',
      'update': 'Guncelle',
      'completedDays': 'Tamamlanan gunler',
      'completionRate': 'Tamamlama orani',
      'monthlyCompletions': 'Aylik tamamlamalar',
      'restore': 'Geri yukle',
      'delete': 'Sil',
      'cancel': 'Iptal',
      'noArchivedHabits': 'Henuz arsivlenmis aliskanlik yok.',
      'shareSummary': 'Ilerleme ozeti',
    }),
    'ru': _merge(_en, {
      'month': 'Mesyats',
      'week': 'Nedelya',
      'year': 'God',
      'statistics': 'Statistika',
      'settings': 'Nastroiki',
      'theme': 'Tema',
      'language': 'Yazyk',
      'archive': 'Arkhiv',
      'privacyPolicy': 'Politika konfidentsialnosti',
      'defaultTheme': 'Po umolchaniyu',
      'light': 'Svetlaya',
      'dark': 'Temnaya',
      'complete': 'Vypolnit',
      'calendar': 'Kalendar',
      'notes': 'Zametki',
      'edit': 'Izmenit',
      'share': 'Podelitsya',
      'saveNote': 'Sohranit zametku',
      'noteForDay': 'Zametka',
      'createHabit': 'Sozdat privychku',
      'editHabit': 'Izmenit privychku',
      'title': 'Nazvanie',
      'description': 'Opisanie',
      'pickIcon': 'Vybrat ikonku',
      'category': 'Kategoriya',
      'completionsPerDay': 'Vypolneniy v den',
      'reminder': 'Napominanie',
      'pickTime': 'Vybrat vremya',
      'showStreak': 'Pokazat seriyu',
      'daily': 'Kazhdyy den',
      'weekly': 'Ezhenedelno',
      'save': 'Sohranit',
      'update': 'Obnovit',
      'completedDays': 'Vypolnennye dni',
      'completionRate': 'Protsent vypolneniya',
      'monthlyCompletions': 'Vypolneniya po mesyatsam',
      'restore': 'Vosstanovit',
      'delete': 'Udalit',
      'cancel': 'Otmena',
      'noArchivedHabits': 'Arkhirovannykh privychek poka net.',
      'shareSummary': 'Svodka progressa',
    }),
    'uk': _merge(_en, {
      'month': 'Misyats',
      'week': 'Tyzhden',
      'year': 'Rik',
      'statistics': 'Statystyka',
      'settings': 'Nalashtuvannya',
      'theme': 'Tema',
      'language': 'Mova',
      'archive': 'Arkhiv',
      'privacyPolicy': 'Polityka konfidentsiinosti',
      'defaultTheme': 'Typovo',
      'light': 'Svitla',
      'dark': 'Temna',
      'complete': 'Vykonaty',
      'calendar': 'Kalendar',
      'notes': 'Notatky',
      'edit': 'Redahuvaty',
      'share': 'Podilitysya',
      'saveNote': 'Zberehty notatku',
      'noteForDay': 'Notatka',
      'createHabit': 'Stvoryty zvychku',
      'editHabit': 'Redahuvaty zvychku',
      'title': 'Nazva',
      'description': 'Opys',
      'pickIcon': 'Obraty ikonku',
      'category': 'Katehoriya',
      'completionsPerDay': 'Vykonan na den',
      'reminder': 'Nahaduvannya',
      'pickTime': 'Obraty chas',
      'showStreak': 'Pokazaty seriyu',
      'daily': 'Shchodnya',
      'weekly': 'Shchotyzhnya',
      'save': 'Zberehty',
      'update': 'Onovyty',
      'completedDays': 'Vykonani dni',
      'completionRate': 'Riven vykonannya',
      'monthlyCompletions': 'Misyachni vykonannya',
      'restore': 'Vidnovyty',
      'delete': 'Vydalyty',
      'cancel': 'Skasuvaty',
      'noArchivedHabits': 'Shche nemae arkhivovanykh zvychok.',
      'shareSummary': 'Pidsumok progresu',
    }),
    'zh': _merge(_en, {
      'month': 'Yue',
      'week': 'Zhou',
      'year': 'Nian',
      'statistics': 'Tongji',
      'settings': 'Shezhi',
      'theme': 'Zhuti',
      'language': 'Yuyan',
      'archive': 'Guicang',
      'privacyPolicy': 'Yinsi zhengce',
      'defaultTheme': 'Moren',
      'light': 'Mingliang',
      'dark': 'Shense',
      'complete': 'Wancheng',
      'calendar': 'Rili',
      'notes': 'Biji',
      'edit': 'Bianji',
      'share': 'Fenxiang',
      'saveNote': 'Baocun biji',
      'noteForDay': 'Biji',
      'createHabit': 'Chuangjian xiguan',
      'editHabit': 'Bianji xiguan',
      'title': 'Biaoti',
      'description': 'Miaoshu',
      'pickIcon': 'Xuanze tubiao',
      'category': 'Fenlei',
      'completionsPerDay': 'Meitian cishu',
      'reminder': 'Tixing',
      'pickTime': 'Xuanze shijian',
      'showStreak': 'Xianshi lianxu',
      'daily': 'Meiri',
      'weekly': 'Meizhou',
      'save': 'Baocun',
      'update': 'Gengxin',
      'completedDays': 'Wancheng tianshu',
      'completionRate': 'Wancheng lv',
      'monthlyCompletions': 'Meiyue wancheng',
      'restore': 'Huifu',
      'delete': 'Shanchu',
      'cancel': 'Quxiao',
      'noArchivedHabits': 'Hai mei you guicang de xiguan.',
      'shareSummary': 'Jindu zhaiyao',
    }),
    'ja': _merge(_en, {
      'month': 'Getsu',
      'week': 'Shukan',
      'year': 'Nen',
      'statistics': 'Tokei',
      'settings': 'Settei',
      'theme': 'Tema',
      'language': 'Gengo',
      'archive': 'Akaibu',
      'privacyPolicy': 'Puraibashi porishi',
      'defaultTheme': 'Deforuto',
      'light': 'Raito',
      'dark': 'Daku',
      'complete': 'Kanryo',
      'calendar': 'Karenda',
      'notes': 'Noto',
      'edit': 'Henshu',
      'share': 'Shea',
      'saveNote': 'Noto o hozon',
      'noteForDay': 'Noto',
      'createHabit': 'Shukan o sakusei',
      'editHabit': 'Shukan o henshu',
      'title': 'Taitoru',
      'description': 'Setsumei',
      'pickIcon': 'Aikon o erabu',
      'category': 'Kategori',
      'completionsPerDay': '1 nichi no tassei su',
      'reminder': 'Rimainda',
      'pickTime': 'Jikan o erabu',
      'showStreak': 'Renzo o hyoji',
      'daily': 'Mainichi',
      'weekly': 'Maishu',
      'save': 'Hozon',
      'update': 'Koshin',
      'completedDays': 'Kanryo shita hi',
      'completionRate': 'Tassei ritsu',
      'monthlyCompletions': 'Getsu betsu tassei',
      'restore': 'Fukugen',
      'delete': 'Sakujo',
      'cancel': 'Kyanseru',
      'noArchivedHabits': 'Akaibu shita shukan wa mada arimasen.',
      'shareSummary': 'Shinchoku no matome',
    }),
    'ko': _merge(_en, {
      'month': 'Wol',
      'week': 'Ju',
      'year': 'Nyeon',
      'statistics': 'Tonggye',
      'settings': 'Seoljeong',
      'theme': 'Tema',
      'language': 'Eoneo',
      'archive': 'Akaibeu',
      'privacyPolicy': 'Peuraibasi jeongchaek',
      'defaultTheme': 'Gibon',
      'light': 'Balgeun',
      'dark': 'Eoduun',
      'complete': 'Wallyo',
      'calendar': 'Dallyeok',
      'notes': 'Memo',
      'edit': 'Pyeonjip',
      'share': 'Gongyu',
      'saveNote': 'Memo jeojang',
      'noteForDay': 'Memo',
      'createHabit': 'Seupgwan mandeulgi',
      'editHabit': 'Seupgwan pyeonjip',
      'title': 'Jemok',
      'description': 'Seolmyeong',
      'pickIcon': 'Aikon seontaek',
      'category': 'Beomju',
      'completionsPerDay': 'Haru wallyo hoesu',
      'reminder': 'Alrim',
      'pickTime': 'Sigan seontaek',
      'showStreak': 'Yeonsok pyosi',
      'daily': 'Maeil',
      'weekly': 'Maejwu',
      'save': 'Jeojang',
      'update': 'Eobdeiteu',
      'completedDays': 'Wallyodoen nal',
      'completionRate': 'Wallyo biyul',
      'monthlyCompletions': 'Wolgan wallyo',
      'restore': 'Bokwon',
      'delete': 'Sakje',
      'cancel': 'Chwiso',
      'noArchivedHabits': 'Ajik akaibeu doen seupgwani eopseumnida.',
      'shareSummary': 'Jinhaeng yoyak',
    }),
    'vi': _merge(_en, {
      'month': 'Thang',
      'week': 'Tuan',
      'year': 'Nam',
      'statistics': 'Thong ke',
      'settings': 'Cai dat',
      'theme': 'Giao dien',
      'language': 'Ngon ngu',
      'archive': 'Luu tru',
      'privacyPolicy': 'Chinh sach rieng tu',
      'defaultTheme': 'Mac dinh',
      'light': 'Sang',
      'dark': 'Toi',
      'complete': 'Hoan thanh',
      'calendar': 'Lich',
      'notes': 'Ghi chu',
      'edit': 'Chinh sua',
      'share': 'Chia se',
      'saveNote': 'Luu ghi chu',
      'noteForDay': 'Ghi chu',
      'createHabit': 'Tao thoi quen',
      'editHabit': 'Chinh sua thoi quen',
      'title': 'Tieu de',
      'description': 'Mo ta',
      'pickIcon': 'Chon bieu tuong',
      'category': 'Danh muc',
      'completionsPerDay': 'So lan hoan thanh moi ngay',
      'reminder': 'Nhac nho',
      'pickTime': 'Chon gio',
      'showStreak': 'Hien chuoi',
      'daily': 'Hang ngay',
      'weekly': 'Hang tuan',
      'save': 'Luu',
      'update': 'Cap nhat',
      'completedDays': 'Ngay hoan thanh',
      'completionRate': 'Ty le hoan thanh',
      'monthlyCompletions': 'Hoan thanh theo thang',
      'restore': 'Khoi phuc',
      'delete': 'Xoa',
      'cancel': 'Huy',
      'noArchivedHabits': 'Chua co thoi quen nao trong luu tru.',
      'shareSummary': 'Tom tat tien do',
    }),
    'ar': _merge(_en, {
      'month': 'Shahr',
      'week': 'Usbu',
      'year': 'Sana',
      'statistics': 'Ihsaiyat',
      'settings': 'Iidadat',
      'theme': 'Mawdu',
      'language': 'Lugha',
      'archive': 'Arshif',
      'privacyPolicy': 'Siyasat alkhususiyya',
      'defaultTheme': 'Iftiradi',
      'light': 'Fateh',
      'dark': 'Daakin',
      'complete': 'Itmam',
      'calendar': 'Taqwim',
      'notes': 'Mulahazat',
      'edit': 'Tahrir',
      'share': 'Musharaka',
      'saveNote': 'Hifz almulahaza',
      'noteForDay': 'Mulahaza',
      'createHabit': 'Insha ada',
      'editHabit': 'Tahrir alada',
      'title': 'Unwan',
      'description': 'Wasf',
      'pickIcon': 'Ikhtar ramz',
      'category': 'Fia',
      'completionsPerDay': 'Adad alitmam fi alyawm',
      'reminder': 'Tadhkir',
      'pickTime': 'Ikhtar alwaqt',
      'showStreak': 'Izhar alsilsila',
      'daily': 'Yawmiy',
      'weekly': 'Usbuaiy',
      'save': 'Hifz',
      'update': 'Tahdith',
      'completedDays': 'Alayam almukmala',
      'completionRate': 'Nisbat alitmam',
      'monthlyCompletions': 'Itmam shahri',
      'restore': 'Iistirada',
      'delete': 'Hadhf',
      'cancel': 'Ilgha',
      'noArchivedHabits': 'La tawjud adat mahfuzah baad.',
      'shareSummary': 'Mulakhkhas altaqaddum',
    }),
    'id': _merge(_en, {
      'month': 'Bulan',
      'week': 'Minggu',
      'year': 'Tahun',
      'statistics': 'Statistik',
      'settings': 'Pengaturan',
      'theme': 'Tema',
      'language': 'Bahasa',
      'archive': 'Arsip',
      'privacyPolicy': 'Kebijakan privasi',
      'defaultTheme': 'Default',
      'light': 'Terang',
      'dark': 'Gelap',
      'complete': 'Selesai',
      'calendar': 'Kalender',
      'notes': 'Catatan',
      'edit': 'Ubah',
      'share': 'Bagikan',
      'saveNote': 'Simpan catatan',
      'noteForDay': 'Catatan',
      'createHabit': 'Buat kebiasaan',
      'editHabit': 'Ubah kebiasaan',
      'title': 'Judul',
      'description': 'Deskripsi',
      'pickIcon': 'Pilih ikon',
      'category': 'Kategori',
      'completionsPerDay': 'Selesai per hari',
      'reminder': 'Pengingat',
      'pickTime': 'Pilih waktu',
      'showStreak': 'Tampilkan streak',
      'daily': 'Harian',
      'weekly': 'Mingguan',
      'save': 'Simpan',
      'update': 'Perbarui',
      'completedDays': 'Hari selesai',
      'completionRate': 'Tingkat penyelesaian',
      'monthlyCompletions': 'Penyelesaian bulanan',
      'restore': 'Pulihkan',
      'delete': 'Hapus',
      'cancel': 'Batal',
      'noArchivedHabits': 'Belum ada kebiasaan di arsip.',
      'shareSummary': 'Ringkasan progres',
    }),
    'th': _merge(_en, {
      'month': 'เดือน',
      'week': 'สัปดาห์',
      'year': 'ปี',
      'statistics': 'สถิติ',
      'settings': 'ตั้งค่า',
      'theme': 'ธีม',
      'language': 'ภาษา',
      'archive': 'เก็บถาวร',
      'privacyPolicy': 'นโยบายความเป็นส่วนตัว',
      'defaultTheme': 'ค่าเริ่มต้น',
      'light': 'สว่าง',
      'dark': 'มืด',
      'complete': 'เสร็จ',
      'edit': 'แก้ไข',
      'share': 'แชร์',
      'createHabit': 'สร้างนิสัย',
      'editHabit': 'แก้ไขนิสัย',
      'title': 'ชื่อ',
      'description': 'คำอธิบาย',
      'pickIcon': 'เลือกไอคอน',
      'category': 'หมวดหมู่',
      'reminder': 'การแจ้งเตือน',
      'pickTime': 'เลือกเวลา',
      'daily': 'ทุกวัน',
      'weekly': 'ทุกสัปดาห์',
      'save': 'บันทึก',
      'update': 'อัปเดต',
      'completedDays': 'วันที่เสร็จ',
      'completionRate': 'อัตราความสำเร็จ',
      'monthlyCompletions': 'ความสำเร็จรายเดือน',
      'restore': 'กู้คืน',
      'delete': 'ลบ',
      'cancel': 'ยกเลิก',
      'noArchivedHabits': 'ไม่มีนิสัยที่เก็บถาวร',
    }),
    'hi': _merge(_en, {
      'month': 'महीना',
      'week': 'सप्ताह',
      'year': 'वर्ष',
      'statistics': 'आँकड़े',
      'settings': 'सेटिंग्स',
      'theme': 'थीम',
      'language': 'भाषा',
      'archive': 'संग्रह',
      'privacyPolicy': 'गोपनीयता नीति',
      'defaultTheme': 'डिफ़ॉल्ट',
      'light': 'हल्का',
      'dark': 'गहरा',
      'complete': 'पूर्ण',
      'edit': 'संपादित करें',
      'share': 'साझा करें',
      'createHabit': 'आदत बनाएं',
      'editHabit': 'आदत संपादित करें',
      'title': 'शीर्षक',
      'description': 'विवरण',
      'pickIcon': 'आइकन चुनें',
      'category': 'श्रेणी',
      'reminder': 'अनुस्मारक',
      'pickTime': 'समय चुनें',
      'daily': 'दैनिक',
      'weekly': 'साप्ताहिक',
      'save': 'सहेजें',
      'update': 'अपडेट',
      'completedDays': 'पूर्ण दिन',
      'completionRate': 'पूर्णता दर',
      'monthlyCompletions': 'मासिक पूर्णता',
      'restore': 'पुनर्स्थापित करें',
      'delete': 'हटाएं',
      'cancel': 'रद्द करें',
      'noArchivedHabits': 'कोई संग्रहीत आदत नहीं।',
      'notifications': 'सूचनाएं',
      'notificationsDescription': 'अनुस्मारक प्रबंधित करें',
      'noHabitsYet': 'अभी कोई आदत नहीं।',
      'tapPlusCreate': '+ दबाएं और बनाएं।',
    }),
    'nl': _merge(_en, {
      'month': 'Maand',
      'week': 'Week',
      'year': 'Jaar',
      'statistics': 'Statistieken',
      'settings': 'Instellingen',
      'theme': 'Thema',
      'language': 'Taal',
      'archive': 'Archief',
      'privacyPolicy': 'Privacybeleid',
      'defaultTheme': 'Standaard',
      'light': 'Licht',
      'dark': 'Donker',
      'complete': 'Voltooid',
      'edit': 'Bewerken',
      'share': 'Delen',
      'createHabit': 'Gewoonte maken',
      'editHabit': 'Gewoonte bewerken',
      'title': 'Titel',
      'description': 'Beschrijving',
      'pickIcon': 'Kies pictogram',
      'category': 'Categorie',
      'reminder': 'Herinnering',
      'pickTime': 'Kies tijd',
      'daily': 'Dagelijks',
      'weekly': 'Wekelijks',
      'save': 'Opslaan',
      'update': 'Bijwerken',
      'completedDays': 'Voltooide dagen',
      'completionRate': 'Voltooiingspercentage',
      'monthlyCompletions': 'Maandelijkse voltooiingen',
      'restore': 'Herstellen',
      'delete': 'Verwijderen',
      'cancel': 'Annuleren',
      'noArchivedHabits': 'Geen gearchiveerde gewoonten.',
      'notifications': 'Meldingen',
      'noHabitsYet': 'Nog geen gewoonten.',
      'tapPlusCreate': 'Tik + om er een te maken.',
    }),
    'pl': _merge(_en, {
      'month': 'Miesiąc',
      'week': 'Tydzień',
      'year': 'Rok',
      'statistics': 'Statystyki',
      'settings': 'Ustawienia',
      'theme': 'Motyw',
      'language': 'Język',
      'archive': 'Archiwum',
      'privacyPolicy': 'Polityka prywatności',
      'defaultTheme': 'Domyślny',
      'light': 'Jasny',
      'dark': 'Ciemny',
      'complete': 'Ukończono',
      'edit': 'Edytuj',
      'share': 'Udostępnij',
      'createHabit': 'Utwórz nawyk',
      'editHabit': 'Edytuj nawyk',
      'title': 'Tytuł',
      'description': 'Opis',
      'pickIcon': 'Wybierz ikonę',
      'category': 'Kategoria',
      'reminder': 'Przypomnienie',
      'pickTime': 'Wybierz czas',
      'daily': 'Codziennie',
      'weekly': 'Co tydzień',
      'save': 'Zapisz',
      'update': 'Aktualizuj',
      'completedDays': 'Ukończone dni',
      'completionRate': 'Wskaźnik ukończenia',
      'monthlyCompletions': 'Miesięczne ukończenia',
      'restore': 'Przywróć',
      'delete': 'Usuń',
      'cancel': 'Anuluj',
      'noArchivedHabits': 'Brak zarchiwizowanych nawyków.',
      'notifications': 'Powiadomienia',
      'noHabitsYet': 'Brak nawyków.',
      'tapPlusCreate': 'Naciśnij +, aby dodać.',
    }),
    'sv': _merge(_en, {
      'month': 'Månad',
      'week': 'Vecka',
      'year': 'År',
      'statistics': 'Statistik',
      'settings': 'Inställningar',
      'theme': 'Tema',
      'language': 'Språk',
      'archive': 'Arkiv',
      'privacyPolicy': 'Integritetspolicy',
      'defaultTheme': 'Standard',
      'light': 'Ljust',
      'dark': 'Mörkt',
      'complete': 'Klar',
      'edit': 'Redigera',
      'share': 'Dela',
      'createHabit': 'Skapa vana',
      'editHabit': 'Redigera vana',
      'title': 'Titel',
      'description': 'Beskrivning',
      'pickIcon': 'Välj ikon',
      'category': 'Kategori',
      'reminder': 'Påminnelse',
      'pickTime': 'Välj tid',
      'daily': 'Dagligen',
      'weekly': 'Veckovis',
      'save': 'Spara',
      'update': 'Uppdatera',
      'completedDays': 'Avklarade dagar',
      'completionRate': 'Fullförandetal',
      'monthlyCompletions': 'Månatliga fullföranden',
      'restore': 'Återställ',
      'delete': 'Radera',
      'cancel': 'Avbryt',
      'noArchivedHabits': 'Inga arkiverade vanor.',
      'notifications': 'Aviseringar',
      'noHabitsYet': 'Inga vanor ännu.',
      'tapPlusCreate': 'Tryck + för att skapa.',
    }),
  };

  static final Map<String, List<String>> _monthLabels = {
    'en': ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    'es': ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
    'de': ['Jan', 'Feb', 'Mar', 'Apr', 'Mai', 'Jun', 'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'],
    'fr': ['Jan', 'Fev', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aou', 'Sep', 'Oct', 'Nov', 'Dec'],
    'it': ['Gen', 'Feb', 'Mar', 'Apr', 'Mag', 'Giu', 'Lug', 'Ago', 'Set', 'Ott', 'Nov', 'Dic'],
    'pt': ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'],
    'hu': ['Jan', 'Feb', 'Mar', 'Apr', 'Maj', 'Jun', 'Jul', 'Aug', 'Sze', 'Okt', 'Nov', 'Dec'],
    'ro': ['Ian', 'Feb', 'Mar', 'Apr', 'Mai', 'Iun', 'Iul', 'Aug', 'Sep', 'Oct', 'Noi', 'Dec'],
    'tr': ['Oca', 'Sub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Agu', 'Eyl', 'Eki', 'Kas', 'Ara'],
    'ru': ['Yan', 'Fev', 'Mar', 'Apr', 'Mai', 'Iyn', 'Iyl', 'Avg', 'Sen', 'Okt', 'Noy', 'Dek'],
    'uk': ['Sic', 'Lyu', 'Ber', 'Kvi', 'Tra', 'Che', 'Lyp', 'Ser', 'Ver', 'Zho', 'Lys', 'Gru'],
    'zh': ['1Y', '2Y', '3Y', '4Y', '5Y', '6Y', '7Y', '8Y', '9Y', '10Y', '11Y', '12Y'],
    'ja': ['1Ga', '2Ga', '3Ga', '4Ga', '5Ga', '6Ga', '7Ga', '8Ga', '9Ga', '10Ga', '11Ga', '12Ga'],
    'ko': ['1W', '2W', '3W', '4W', '5W', '6W', '7W', '8W', '9W', '10W', '11W', '12W'],
    'vi': ['Th1', 'Th2', 'Th3', 'Th4', 'Th5', 'Th6', 'Th7', 'Th8', 'Th9', 'Th10', 'Th11', 'Th12'],
    'ar': ['Yan', 'Feb', 'Mar', 'Abr', 'Mai', 'Yun', 'Yul', 'Agh', 'Seb', 'Okt', 'Nov', 'Dis'],
    'id': ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'],
    'th': ['ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'],
    'hi': ['जन', 'फर', 'मार', 'अप्र', 'मई', 'जून', 'जुल', 'अग', 'सित', 'अक्ट', 'नव', 'दिस'],
    'nl': ['Jan', 'Feb', 'Mrt', 'Apr', 'Mei', 'Jun', 'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dec'],
    'pl': ['Sty', 'Lut', 'Mar', 'Kwi', 'Maj', 'Cze', 'Lip', 'Sie', 'Wrz', 'Paź', 'Lis', 'Gru'],
    'sv': ['Jan', 'Feb', 'Mar', 'Apr', 'Maj', 'Jun', 'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dec'],
  };

  static final Map<String, List<String>> _weekdayLabels = {
    'en': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    'es': ['Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab', 'Dom'],
    'de': ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'],
    'fr': ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'],
    'it': ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'],
    'pt': ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom'],
    'hu': ['Het', 'Ke', 'Sze', 'Csu', 'Pe', 'Szo', 'Va'],
    'ro': ['Lun', 'Mar', 'Mie', 'Joi', 'Vin', 'Sam', 'Dum'],
    'tr': ['Pzt', 'Sal', 'Car', 'Per', 'Cum', 'Cmt', 'Paz'],
    'ru': ['Pon', 'Vto', 'Sre', 'Che', 'Pya', 'Sub', 'Vos'],
    'uk': ['Pon', 'Viv', 'Ser', 'Che', 'Pya', 'Sub', 'Ned'],
    'zh': ['Z1', 'Z2', 'Z3', 'Z4', 'Z5', 'Z6', 'Z7'],
    'ja': ['Ge', 'Ka', 'Sui', 'Mo', 'Kin', 'Do', 'Ni'],
    'ko': ['Wol', 'Hwa', 'Su', 'Mok', 'Geu', 'To', 'Il'],
    'vi': ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
    'ar': ['Ith', 'Thu', 'Arb', 'Kha', 'Jum', 'Sab', 'Aha'],
    'id': ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'],
    'th': ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'],
    'hi': ['सोम', 'मंग', 'बुध', 'गुरु', 'शुक्र', 'शनि', 'रवि'],
    'nl': ['Ma', 'Di', 'Wo', 'Do', 'Vr', 'Za', 'Zo'],
    'pl': ['Pon', 'Wt', 'Śr', 'Czw', 'Pt', 'Sob', 'Nd'],
    'sv': ['Mån', 'Tis', 'Ons', 'Tor', 'Fre', 'Lör', 'Sön'],
  };

  static Map<String, String> _merge(
      Map<String, String> base,
      Map<String, String> values,
      ) =>
      {...base, ...values};

  static String text(String code, String key) {
    return _values[code]?[key] ?? _values['en']![key] ?? key;
  }

  static List<String> months(String code) =>
      _monthLabels[code] ?? _monthLabels['en']!;

  static List<String> weekdays(String code) =>
      _weekdayLabels[code] ?? _weekdayLabels['en']!;q
}

class AppTheme {
  static AppThemeModePreference mode = AppThemeModePreference.light;

  static bool get isDark => mode == AppThemeModePreference.dark;

  static Color get bg => switch (mode) {
    AppThemeModePreference.light => const Color(0xFFFFFFFF),
    AppThemeModePreference.dark => const Color(0xFF0A0A0A),
  };
  static Color get surface => switch (mode) {
    AppThemeModePreference.light => Colors.white,
    AppThemeModePreference.dark => const Color(0xFF141414),
  };
  static Color get border => switch (mode) {
    AppThemeModePreference.light => const Color(0xFF0D0D0D),
    AppThemeModePreference.dark => const Color(0xFF2A2A2A),
  };
  static Color get borderLight => switch (mode) {
    AppThemeModePreference.light => const Color(0xFFE7E2E9),
    AppThemeModePreference.dark => const Color(0xFF1E1E1E),
  };
  static Color get textPrimary => switch (mode) {
    AppThemeModePreference.light => const Color(0xFF16151A),
    AppThemeModePreference.dark => const Color(0xFFF4F3F7),
  };
  static Color get textSecondary => switch (mode) {
    AppThemeModePreference.light => const Color(0xFF6D6770),
    AppThemeModePreference.dark => const Color(0xFFAEAAB6),
  };
  static Color get textTertiary => switch (mode) {
    AppThemeModePreference.light => const Color(0xFFB2ACB4),
    AppThemeModePreference.dark => const Color(0xFF73707A),
  };
  // Card surface: blends with #0A0A0A bg in dark
  static Color get cardSurface => switch (mode) {
    AppThemeModePreference.light => const Color(0xFFFFFFFF),
    AppThemeModePreference.dark => const Color(0xFF111111),
  };
  // Card border: gray in light, #121212 in dark
  static Color get cardBorder => switch (mode) {
    AppThemeModePreference.light => const Color(0xFFD0CCCF),
    AppThemeModePreference.dark => const Color(0xFF1F1F1F),
  };
  // Upcoming (future) day color
  static Color get upcomingDot => switch (mode) {
    AppThemeModePreference.light => const Color(0xFFCACACA),
    AppThemeModePreference.dark => const Color(0xFF222222),
  };
  // Inactive (not scheduled) day
  static Color get inactiveDot => switch (mode) {
    AppThemeModePreference.light => const Color(0xFFEEEEEE),
    AppThemeModePreference.dark => const Color(0xFF666666),
  };
  // Done dot color
  static Color get doneDot => switch (mode) {
    AppThemeModePreference.light => const Color(0xFF111111),
    AppThemeModePreference.dark => const Color(0xFFFFFFFF),
  };

  static Color get done => switch (mode) {
    AppThemeModePreference.light => const Color(0xFF141318),
    AppThemeModePreference.dark => const Color(0xFFF3F2F7),
  };
  static Color get gray => switch (mode) {
    AppThemeModePreference.light => const Color(0xFFF2EEF4),
    AppThemeModePreference.dark => const Color(0xFF2A2A31),
  };
  // Faint border for icon circles inside cards
  static Color get faintBorder => switch (mode) {
    AppThemeModePreference.light => const Color(0xFFE8E4E6),
    AppThemeModePreference.dark => const Color(0xFF252525),
  };
  static Color get navActive => textPrimary;
  static Color get navInactive => textTertiary;
  static Color get divider => borderLight;
  static Color get danger => const Color(0xFF8B1E1E);

  static ThemeData themeData({required bool dark}) {
    final scheme = dark
        ? ColorScheme.dark(
      primary: textPrimary,
      surface: surface,
    )
        : ColorScheme.light(
      primary: textPrimary,
      surface: surface,
    );
    return ThemeData(
      useMaterial3: false,
      brightness: dark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: bg,
      fontFamily: 'Inter_18pt',
      colorScheme: scheme,
      dividerColor: divider,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: textPrimary,
        selectionHandleColor: textPrimary,
        selectionColor: textPrimary.withOpacity(0.18),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  MODELS
// ═══════════════════════════════════════════════════════════

enum StreakType { daily, weekly }

class HabitReminder {
  final Set<int> days; // 0=Mon..6=Sun
  final TimeOfDay time;
  HabitReminder({required this.days, required this.time});

  Map<String, dynamic> toJson() =>
      {'days': days.toList(), 'hour': time.hour, 'minute': time.minute};

  factory HabitReminder.fromJson(Map<String, dynamic> j) => HabitReminder(
    days: Set<int>.from(j['days'] as List),
    time: TimeOfDay(hour: j['hour'] as int, minute: j['minute'] as int),
  );
}

class Habit {
  final String id;
  String title;
  String description;
  int iconCodePoint;
  String category;
  int completionsPerDay;
  HabitReminder reminder;
  StreakType streakType;
  bool showStreak;
  bool archived;
  bool notificationEnabled;
  Map<String, int> completions;

  Habit({
    required this.id,
    required this.title,
    this.description = '',
    required this.iconCodePoint,
    this.category = '',
    this.completionsPerDay = 1,
    required this.reminder,
    this.streakType = StreakType.daily,
    this.showStreak = true,
    this.archived = false,
    this.notificationEnabled = false,
    Map<String, int>? completions,
  }) : completions = completions ?? {};


  IconData get iconData => _iconFromCP(iconCodePoint);

  static String dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  bool isCompletedOn(DateTime date) =>
      (completions[dateKey(date)] ?? 0) >= completionsPerDay;

  bool isScheduledOn(DateTime date) {
    if (reminder.days.isEmpty) return true;
    return reminder.days.contains(date.weekday - 1);
  }

  int currentDailyStreak() {
    int s = 0;
    final now = DateTime.now();
    for (int i = 0; i < 400; i++) {
      final d = now.subtract(Duration(days: i));
      if (!isScheduledOn(d)) continue;
      if (isCompletedOn(d)) s++; else break;
    }
    return s;
  }

  int bestDailyStreak() {
    if (completions.isEmpty) return 0;
    final dates = completions.entries
        .where((e) => e.value >= completionsPerDay)
        .map((e) => DateTime.parse(e.key))
        .toList()..sort();
    int best = 0, cur = 0;
    DateTime? prev;
    for (final d in dates) {
      cur = (prev != null && d.difference(prev).inDays == 1) ? cur + 1 : 1;
      if (cur > best) best = cur;
      prev = d;
    }
    return best;
  }

  int currentWeeklyStreak() {
    int s = 0;
    final now = DateTime.now();
    final mon0 = now.subtract(Duration(days: now.weekday - 1));
    for (int w = 0; w < 52; w++) {
      final mon = mon0.subtract(Duration(days: w * 7));
      bool any = false;
      for (int i = 0; i < 7; i++) {
        final d = mon.add(Duration(days: i));
        if (d.isAfter(now)) continue;
        if (isCompletedOn(d)) { any = true; break; }
      }
      if (any) s++; else break;
    }
    return s;
  }

  int bestWeeklyStreak() {
    if (completions.isEmpty) return 0;
    final dates = completions.entries
        .where((e) => e.value >= completionsPerDay)
        .map((e) => DateTime.parse(e.key))
        .toList()..sort();
    Set<int> weeks = {};
    for (final d in dates) {
      final mon = d.subtract(Duration(days: d.weekday - 1));
      weeks.add(mon.millisecondsSinceEpoch);
    }
    final sorted = weeks.toList()..sort();
    int best = 0, cur = 0;
    int? prev;
    const week = 7 * 24 * 60 * 60 * 1000;
    for (final w in sorted) {
      cur = (prev != null && w - prev == week) ? cur + 1 : 1;
      if (cur > best) best = cur;
      prev = w;
    }
    return best;
  }

  int completedDaysInYear(int year) => completions.entries
      .where((e) => e.value >= completionsPerDay && e.key.startsWith('$year'))
      .length;

  double completionRateInYear(int year) {
    final start = DateTime(year, 1, 1);
    final end = year == DateTime.now().year ? DateTime.now() : DateTime(year, 12, 31);
    int scheduled = 0, done = 0;
    for (DateTime d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
      if (isScheduledOn(d)) { scheduled++; if (isCompletedOn(d)) done++; }
    }
    return scheduled == 0 ? 0 : done / scheduled;
  }

  List<int> monthlyCompletions(int year) => List.generate(12, (m) {
    final prefix = '$year-${(m + 1).toString().padLeft(2, '0')}';
    return completions.entries
        .where((e) => e.value >= completionsPerDay && e.key.startsWith(prefix))
        .length;
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'iconCodePoint': iconCodePoint,
    'category': category,
    'completionsPerDay': completionsPerDay,
    'reminder': reminder.toJson(),
    'streakType': streakType.index,
    'showStreak': showStreak,
    'archived': archived,
    'notificationEnabled': notificationEnabled,
    'completions': completions,
  };

  factory Habit.fromJson(Map<String, dynamic> j) => Habit(
    id: j['id'] as String,
    title: j['title'] as String,
    description: j['description'] as String? ?? '',
    iconCodePoint: j['iconCodePoint'] as int? ?? kDefaultHabitIcon.codePoint,
    category: j['category'] as String? ?? '',
    completionsPerDay: j['completionsPerDay'] as int? ?? 1,
    reminder: HabitReminder.fromJson(Map<String, dynamic>.from(j['reminder'] as Map)),
    streakType: StreakType.values[j['streakType'] as int? ?? 0],
    showStreak: j['showStreak'] as bool? ?? true,
    archived: j['archived'] as bool? ?? false,
    notificationEnabled: j['notificationEnabled'] as bool? ?? false,
    completions: Map<String, int>.from(j['completions'] as Map? ?? {}),
  );
}

// ═══════════════════════════════════════════════════════════
//  STORE
// ═══════════════════════════════════════════════════════════

class HabitStore extends ChangeNotifier {
  final List<Habit> _habits = [];
  bool _loaded = false;
  AppThemeModePreference themePreference = AppThemeModePreference.light;
  String languageCode = 'en';
  bool notificationsEnabled = false;

  List<Habit> get habits => _habits.where((h) => !h.archived).toList();
  List<Habit> get archivedHabits => _habits.where((h) => h.archived).toList();
  String text(String key) => AppStrings.text(languageCode, key);

  /// Returns a File in the user's home / documents folder.
  static Future<File> _storageFile() async {
    final home = Platform.environment['USERPROFILE'] ??
        Platform.environment['HOME'] ??
        Directory.systemTemp.path;
    final dir = Platform.isAndroid
        ? Directory('/data/data/com.example.doingnow/files/.doingnow')
        : Directory('$home/.doingnow');
    if (!await dir.exists()) await dir.create(recursive: true);
    return File('${dir.path}/habits_v1.json');
  }

  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    try {
      final file = await _storageFile();
      if (await file.exists()) {
        final raw = await file.readAsString();
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          _habits.addAll(
            decoded.map((e) => Habit.fromJson(Map<String, dynamic>.from(e as Map))),
          );
        } else if (decoded is Map) {
          final settings = Map<String, dynamic>.from(decoded['settings'] as Map? ?? {});
          final themeName = settings['theme'] as String? ?? 'light';
          themePreference = AppThemeModePreference.values.firstWhere(
                (value) => value.name == themeName,
            orElse: () => AppThemeModePreference.light,
          );
          languageCode = settings['languageCode'] as String? ?? 'en';
          notificationsEnabled = settings['notificationsEnabled'] as bool? ?? false;

          final habitsRaw = decoded['habits'] as List? ?? const [];
          _habits.addAll(
            habitsRaw.map((e) => Habit.fromJson(Map<String, dynamic>.from(e as Map))),
          );
        }
        AppTheme.mode = themePreference;
        notifyListeners();
        // Restore any scheduled notifications after app restart
        if (notificationsEnabled) {
          NotificationService.instance.rescheduleAll(_habits);
        }
      }
    } catch (e) {
      // Back up corrupt file rather than silently wiping data
      try {
        final file = await _storageFile();
        if (await file.exists()) {
          final backup = File('${file.path}.bak');
          await file.copy(backup.path);
        }
      } catch (_) {}
    }
  }

  Timer? _saveTimer;

  void _save() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 400), _doSave);
  }

  Future<void> _doSave() async {
    try {
      final file = await _storageFile();
      final data = jsonEncode({
        'settings': {
          'theme': themePreference.name,
          'languageCode': languageCode,
          'notificationsEnabled': notificationsEnabled,
        },
        'habits': _habits.map((h) => h.toJson()).toList(),
      });
      await file.writeAsString(data);
    } catch (_) {}
  }

  void addHabit(Habit h) {
    _habits.add(h);
    notifyListeners();
    _save();
    if (notificationsEnabled && h.notificationEnabled) {
      NotificationService.instance.requestPermissions().then((_) {
        NotificationService.instance.scheduleHabit(h);
      });
    }
  }

  void updateHabit(Habit h) {
    final i = _habits.indexWhere((x) => x.id == h.id);
    if (i >= 0) {
      _habits[i] = h;
      notifyListeners();
      _save();
      if (notificationsEnabled && h.notificationEnabled) {
        NotificationService.instance.requestPermissions().then((_) {
          NotificationService.instance.scheduleHabit(h);
        });
      } else {
        NotificationService.instance.cancelHabit(h.id);
      }
    }
  }

  void toggleComplete(Habit h, DateTime date) {
    // Only allow toggling today — past and future days are locked
    if (!h.isScheduledOn(date) || !_isSameDate(date, DateTime.now())) return;
    final key = Habit.dateKey(date);
    final cur = h.completions[key] ?? 0;
    if (cur >= h.completionsPerDay) h.completions.remove(key);
    else h.completions[key] = cur + 1;
    notifyListeners(); _save();
  }

  void archiveHabit(String id) {
    final i = _habits.indexWhere((x) => x.id == id);
    if (i >= 0) {
      _habits[i].archived = true;
      notifyListeners();
      _save();
      NotificationService.instance.cancelHabit(id);
    }
  }

  void restoreHabit(String id) {
    final i = _habits.indexWhere((x) => x.id == id);
    if (i >= 0) {
      _habits[i].archived = false;
      notifyListeners();
      _save();
      if (notificationsEnabled && _habits[i].notificationEnabled) {
        NotificationService.instance.requestPermissions().then((_) {
          NotificationService.instance.scheduleHabit(_habits[i]);
        });
      }
    }
  }

  void deleteHabit(String id) {
    NotificationService.instance.cancelHabit(id);
    _habits.removeWhere((habit) => habit.id == id);
    notifyListeners();
    _save();
  }


  void updateThemePreference(AppThemeModePreference value) {
    themePreference = value;
    AppTheme.mode = value;
    notifyListeners();
    _save();
  }

  void updateLanguage(String code) {
    languageCode = code;
    notifyListeners();
    _save();
  }

  void updateNotificationsEnabled(bool value) {
    notificationsEnabled = value;
    notifyListeners();
    _save();
    if (value) {
      NotificationService.instance.requestPermissions().then((_) {
        NotificationService.instance.requestBatteryOptimizationAccess();
        NotificationService.instance.rescheduleAll(_habits);
      });
    } else {
      NotificationService.instance.cancelAll();
    }
  }
}

// ═══════════════════════════════════════════════════════════
//  ENTRY POINT
// ═══════════════════════════════════════════════════════════

final _globalStore = HabitStore();

// Constrains content to max 680px on wide screens, centered
class _ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const _ResponsiveWrapper({required this.child, this.maxWidth = 680});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

class _NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) =>
      child;
}

class HabitApp extends StatelessWidget {
  const HabitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _globalStore,
      builder: (_, __) {
        AppTheme.mode = _globalStore.themePreference;
        return MaterialApp(
          title: _globalStore.text('month'),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeData(dark: false),
          darkTheme: AppTheme.themeData(dark: true),
          themeMode: _globalStore.themePreference == AppThemeModePreference.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          scrollBehavior: _NoGlowScrollBehavior(),
          home: _AppRoot(store: _globalStore),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  APP ROOT - Entry Point with Initial Data Load
// ═══════════════════════════════════════════════════════════

class _AppRoot extends StatefulWidget {
  final HabitStore store;
  const _AppRoot({required this.store});

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  bool _ready = false;
  bool _hasOnboarded = false;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardedSync();
    _initData();
  }

  // Sync peek so splash shows logo immediately for returning users
  void _checkOnboardedSync() {
    try {
      final dir = _appDir();
      final flag = File('${dir.path}/onboarded.flag');
      if (flag.existsSync()) _hasOnboarded = true;
    } catch (_) {}
  }

  Directory _appDir() {
    final home = Platform.environment['USERPROFILE'] ??
        Platform.environment['HOME'] ?? Directory.systemTemp.path;
    return Platform.isAndroid
        ? Directory('/data/data/com.example.doingnow/files/.doingnow')
        : Directory('$home/.doingnow');
  }

  Future<File> _settingsFile() async {
    final dir = _appDir();
    if (!await dir.exists()) await dir.create(recursive: true);
    return File('${dir.path}/habits_v1.json');
  }

  Future<void> _initData() async {
    await widget.store.load();
    final flagFile = File('${(await _settingsFile()).parent.path}/onboarded.flag');
    final onboarded = flagFile.existsSync();
    if (!mounted) return;
    setState(() {
      _ready = true;
      _hasOnboarded = onboarded;
      _showOnboarding = !onboarded;
    });
  }

  Future<void> _markOnboardingShown() async {
    try {
      final dir = _appDir();
      if (!await dir.exists()) await dir.create(recursive: true);
      await File('${dir.path}/onboarded.flag').writeAsString('1');
    } catch (_) {}
  }

  void _addDefaultHabit() {
    final now = DateTime.now();
    final random = <String, int>{};
    for (int m = 1; m <= now.month; m++) {
      final daysInMonth = DateTime(now.year, m + 1, 0).day;
      final maxDay = m == now.month ? now.day : daysInMonth;
      for (int d = 1; d <= maxDay; d++) {
        final hash = (m * 31 + d * 17 + now.year * 7) % 100;
        if (hash < 55) {
          random[Habit.dateKey(DateTime(now.year, m, d))] = 1;
        }
      }
    }
    widget.store.addHabit(Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Study',
      iconCodePoint: Icons.menu_book_outlined.codePoint,
      reminder: HabitReminder(
        days: {0, 1, 2, 3, 4, 5, 6},
        time: const TimeOfDay(hour: 9, minute: 0),
      ),
      completions: random,
      notificationEnabled: true,
    ));
  }

  void _onOnboardingComplete() async {
    await _markOnboardingShown();
    _addDefaultHabit();
    widget.store.updateNotificationsEnabled(true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      _showOnboarding = false;
      _hasOnboarded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show onboarding fullscreen — no splash needed for new users
    if (_ready && _showOnboarding) {
      return _OnboardingFlow(onComplete: _onOnboardingComplete);
    }
    // Single persistent _SplashTransition — never recreated so animation
    // state is preserved across the !ready → ready transition.
    // For new users: showLogo=false → skipToApp immediately, HomeScreen visible
    // For returning users: showLogo=true → logo fades in, then progress, then HomeScreen
    return _SplashTransition(
      key: const ValueKey('splash'),
      showLogo: _hasOnboarded,
      ready: _ready,
      child: HomeScreen(store: widget.store),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  SPLASH TRANSITION (Cinematic Reveal)
// ═══════════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════════
//  SPLASH TRANSITION - The Widget
// ═══════════════════════════════════════════════════════════

class _SplashTransition extends StatefulWidget {
  final bool showLogo;
  final bool ready;
  final Widget child;
  const _SplashTransition({
    super.key,
    required this.showLogo,
    required this.ready,
    required this.child,
  });

  @override
  State<_SplashTransition> createState() => _SplashTransitionState();
}

// ═══════════════════════════════════════════════════════════
//  SPLASH TRANSITION - The Logic and UI
// ═══════════════════════════════════════════════════════════

class _SplashTransitionState extends State<_SplashTransition> with TickerProviderStateMixin {
  late final AnimationController _logoCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );
  late final AnimationController _progressCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );
  late final AnimationController _appCtrl = AnimationController(
    vsync: this,
    // INCREASED DURATION: This controls how long the app takes to go from 0% to 100% capacity
    duration: const Duration(milliseconds: 500),
  );

  late final Animation<double> _realisticProgress;
  late final Animation<double> _appFade;
  late final Animation<double> _appScale;

  bool _logoVisible = true;
  bool _progressVisible = false;
  bool _progressFadingOut = false;
  bool _appMounted = false;
  bool _appVisible = false;
  bool _finishingProgress = false;
  bool _logoPhaseDone = false;
  bool _appRevealStarted = false;

  @override
  void initState() {
    super.initState();

    _realisticProgress = _progressCtrl;

    _appFade = CurvedAnimation(parent: _appCtrl, curve: Curves.easeInOutQuart);
    _appScale = Tween<double>(begin: 0.98, end: 1.0).animate(
      CurvedAnimation(parent: _appCtrl, curve: Curves.easeOutCubic),
    );

    _playLogoPhase();
  }

  @override
  void didUpdateWidget(_SplashTransition old) {
    super.didUpdateWidget(old);
    if (!old.ready && widget.ready) {
      _completeProgressPhase();
    }
  }

  Future<void> _playLogoPhase() async {
    await _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    await _logoCtrl.reverse();
    if (!mounted) return;

    setState(() {
      _logoVisible = false;
    });
    _logoPhaseDone = true;
    _startProgressPhase();
  }

  void _startProgressPhase() {
    if (_progressVisible || _appVisible) return;
    setState(() {
      _logoVisible = false;
      _progressVisible = true;
    });
    _progressCtrl.animateTo(
      0.82,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    );
    if (widget.ready) _completeProgressPhase();
  }

  Future<void> _completeProgressPhase() async {
    if (_finishingProgress || _appVisible) return;
    if (!_logoPhaseDone) return;
    if (!_progressVisible) {
      _startProgressPhase();
      return;
    }
    _finishingProgress = true;
    await _progressCtrl.animateTo(
      1.0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
    if (mounted) _startAppReveal();
  }

  Future<void> _startAppReveal() async {
    if (_appRevealStarted) return;
    _appRevealStarted = true;

    setState(() {
      _appMounted = true;
      _progressFadingOut = true;
    });

    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    if (!mounted) return;

    setState(() {
      _progressVisible = false;
      _appVisible = true;
    });

    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;

    _appCtrl.forward(from: 0.0);
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _progressCtrl.dispose();
    _appCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Stack(
        children: [
          // 1. THE APP
          if (_appMounted)
            FadeTransition(
              opacity: _appFade,
              child: ScaleTransition(
                scale: _appScale,
                child: IgnorePointer(
                  ignoring: !_appVisible,
                  child: widget.child,
                ),
              ),
            ),

          // 2. THE PROGRESS BAR LAYER
          if (_progressVisible)
            IgnorePointer(
              child: AnimatedOpacity(
                opacity: _progressFadingOut ? 0.0 : 1.0,
                // FIXED: Changed to 800ms to perfectly match the _appCtrl duration for a 1:1 crossfade
                duration: const Duration(milliseconds: 1000),
                child: Center(
                  child: AnimatedBuilder(
                    animation: _progressCtrl,
                    builder: (context, _) {
                      final val = _realisticProgress.value;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Loading app data...',
                            style: TextStyle(
                              color: AppTheme.textPrimary.withOpacity(0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            width: 160,
                            height: 2,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: AppTheme.textPrimary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: val,
                              child: Container(color: AppTheme.textPrimary),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${(val * 100).clamp(0, 100).toInt()}%',
                            style: TextStyle(
                              color: AppTheme.textPrimary.withOpacity(0.4),
                              fontSize: 12,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),

          // 3. LOGO + "doingnow" TEXT LAYER
          if (_logoVisible)
            FadeTransition(
              opacity: _logoCtrl,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icon.png',
                      width: 80,
                      height: 80,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.auto_graph, size: 50, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'doingnow',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.8,
                        fontFamily: 'Inter_18pt',
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
// ═══════════════════════════════════════════════════════════
//  SLIDE ROUTE (right → left push, left → right pop)
// ═══════════════════════════════════════════════════════════

class _SlideRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  _SlideRoute({required this.child})
      : super(
    pageBuilder: (_, __, ___) => child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (_, animation, secondaryAnimation, child) {
      final slide = Tween<Offset>(
        begin: const Offset(1.0, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ));
      final fadeOut = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.3, 0),
      ).animate(CurvedAnimation(
        parent: secondaryAnimation,
        curve: Curves.easeInCubic,
      ));
      return SlideTransition(
        position: fadeOut,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}



class HomeScreen extends StatefulWidget {
  final HabitStore store;
  const HomeScreen({super.key, required this.store});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  int _prevTab = 0;
  Key _statsKey = UniqueKey();

  Key _yearKey = UniqueKey();

  late final List<Widget> Function() _buildPages = () => [
    MonthTab(store: widget.store),
    WeekTab(store: widget.store),
    YearTab(store: widget.store, key: _yearKey),
    StatisticsTab(store: widget.store, key: _statsKey),
    SettingsTab(store: widget.store),
  ];

  late List<Widget> _pages = _buildPages();

  void _onTabTap(int i) {
    setState(() {
      // Re-mount YearTab when entering — triggers dot fill animation
      if (i == 2 && _tab != 2) {
        _yearKey = UniqueKey();
        _pages = [
          _pages[0],
          _pages[1],
          YearTab(store: widget.store, key: _yearKey),
          _pages[3],
          _pages[4],
        ];
      }
      // Re-mount StatisticsTab when entering — triggers chart animation
      if (i == 3 && _tab != 3) {
        _statsKey = UniqueKey();
        _pages = [
          _pages[0],
          _pages[1],
          _pages[2],
          StatisticsTab(store: widget.store, key: _statsKey),
          _pages[4],
        ];
      }
      _prevTab = _tab;
      _tab = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (_, __) {
        return Scaffold(
          backgroundColor: AppTheme.bg,
          body: IndexedStack(
            index: _tab,
            children: _pages,
          ),
          bottomNavigationBar: _buildNav(),
        );
      },
    );
  }

  Widget _buildNav() {
    final icons = [
      Icons.grid_view_rounded,
      Icons.view_week_outlined,
      Icons.calendar_today_outlined,
      Icons.bar_chart_rounded,
      Icons.settings_outlined,
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.borderLight, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 54,
          child: Row(
            children: List.generate(5, (i) {
              final active = _tab == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onTabTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Icon(icons[i], size: 22,
                        color: active ? AppTheme.navActive : AppTheme.navInactive),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
// ═══════════════════════════════════════════════════════════
//  MONTH TAB
// ═══════════════════════════════════════════════════════════

class MonthTab extends StatelessWidget {
  final HabitStore store;
  const MonthTab({super.key, required this.store});

  int _crossAxisCount(double width) {
    if (width >= 1500) return 6;
    if (width >= 1000) return 5;
    if (width >= 450) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final now = DateTime.now();
        return Scaffold(
          backgroundColor: AppTheme.bg,
          body: SafeArea(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _ResponsiveWrapper(
                child: _TabHeader(title: store.text('month'), onAdd: () => showCreateDialog(context, store)),
              ),
              Expanded(
                child: store.habits.isEmpty
                    ? Center(child: Text(
                    '${store.text('noHabitsYet')}\n${store.text('tapPlusCreate')}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.6)))
                    : LayoutBuilder(
                  builder: (context, constraints) {
                    final cols = _crossAxisCount(constraints.maxWidth);
                    if (cols == 1) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        itemCount: store.habits.length,
                        itemBuilder: (_, i) => RepaintBoundary(
                          child: _MonthCard(habit: store.habits[i], store: store, now: now),
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: cols >= 5 ? 0.75 : cols >= 3 ? 0.85 : 0.9,
                      ),
                      itemCount: store.habits.length,
                      itemBuilder: (_, i) =>
                          RepaintBoundary(child: _MonthCard(habit: store.habits[i], store: store, now: now)),
                    );
                  },
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}

class _MonthCard extends StatelessWidget {
  final Habit habit;
  final HabitStore store;
  final DateTime now;
  const _MonthCard({required this.habit, required this.store, required this.now});

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final startOffset = firstDay.weekday - 1;
    final totalCells = ((startOffset + daysInMonth) / 7).ceil() * 7;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8), // Slightly rounded out the padding for better balance
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.cardBorder, width: 1.0),
      ),
      child: Column(
          mainAxisSize: MainAxisSize.max, // Let the column fill the GridView cell height
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Push header up and calendar down
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER GROUP
            Row(children: [
              Container(
                width: 24, height: 24, // Fixed invalid circle shape dimensions
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.bg,
                  border: Border.all(color: AppTheme.faintBorder),
                ),
                child: Center(child: Icon(habit.iconData, size: 14, color: AppTheme.textPrimary)),
              ),
              const SizedBox(width: 8),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(habit.title,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                if (habit.description.isNotEmpty)
                  Text(habit.description,
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 9),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
              ])),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => showHabitActions(context, habit, store),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
                  child: Icon(Icons.more_horiz, color: AppTheme.textTertiary, size: 20),
                ),
              ),
            ]),

            // CALENDAR GROUP
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: _weekdayLabels(context).map((d) => Expanded(
                  child: Text(d, textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 9, color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500)),
                )).toList()),
                const SizedBox(height: 4),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: totalCells,
                  itemBuilder: (_, i) {
                    final dayNum = i - startOffset + 1;
                    if (dayNum < 1 || dayNum > daysInMonth) {
                      return const _DayCell(type: _CT.gray);
                    }
                    final date = DateTime(now.year, now.month, dayNum);
                    final sched = habit.isScheduledOn(date);
                    final done = habit.isCompletedOn(date);
                    final isToday = _isSameDate(date, now);
                    final isFuture = _isFutureDate(date);
                    final isPast = _isPastDate(date);
                    _CT type;
                    if (!sched) type = _CT.gray;
                    else if (isFuture) type = _CT.empty;
                    else if (done) type = _CT.done;
                    else type = _CT.undone;

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: isToday
                          ? () => _handleHabitDayTap(context, store, habit, date)
                          : null,
                      child: Opacity(
                        opacity: isPast && sched ? 0.55 : 1.0,
                        child: _DayCell(type: type, isToday: isToday),
                      ),
                    );
                  },
                ),
              ],
            ),
          ]),
    );
  }
}
// ═══════════════════════════════════════════════════════════
//  WEEK TAB
// ═══════════════════════════════════════════════════════════

class WeekTab extends StatelessWidget {
  final HabitStore store;
  const WeekTab({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final now = DateTime.now();
        final monday = now.subtract(Duration(days: now.weekday - 1));
        return Scaffold(
          backgroundColor: AppTheme.bg,
          body: SafeArea(
            child: _ResponsiveWrapper(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _TabHeader(title: store.text('week'), onAdd: () => showCreateDialog(context, store)),
                Expanded(
                  child: store.habits.isEmpty
                      ? Center(child: Text(store.text('noHabitsYet'),
                      style: TextStyle(color: AppTheme.textSecondary)))
                      : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    itemCount: store.habits.length,
                    itemBuilder: (_, i) => RepaintBoundary(
                      child: _WeekCard(habit: store.habits[i], store: store, monday: monday, now: now),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}

class _WeekCard extends StatelessWidget {
  final Habit habit;
  final HabitStore store;
  final DateTime monday, now;
  const _WeekCard(
      {required this.habit, required this.store,
        required this.monday, required this.now});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder, width: 1.0),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.bg,
              border: Border.all(color: AppTheme.faintBorder),
            ),
            child: Center(child: Icon(habit.iconData, size: 12, color: AppTheme.textPrimary)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(habit.title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              maxLines: 1, overflow: TextOverflow.ellipsis)),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => showHabitActions(context, habit, store),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.more_horiz, color: AppTheme.textTertiary, size: 15),
            ),
          ),
        ]),
        const SizedBox(height: 10),
        Row(children: List.generate(7, (i) {
          final date = monday.add(Duration(days: i));
          final sched = habit.isScheduledOn(date);
          final done = habit.isCompletedOn(date);
          final isToday = _isSameDate(date, now);
          final isFuture = _isFutureDate(date);
          final isOtherMonth = date.month != now.month;
          final isPast = _isPastDate(date);
          _CT type;
          if (isOtherMonth) type = _CT.gray;
          else if (!sched) type = _CT.gray;
          else if (isFuture) type = _CT.empty;
          else if (done) type = _CT.done;
          else type = _CT.undone;
          return Expanded(
            child: Column(children: [
              Text(
                _weekdayLabels(context)[i],
                style: TextStyle(
                  fontSize: 10,
                  color: isOtherMonth
                      ? AppTheme.textTertiary
                      : AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: isOtherMonth || isPast || isFuture
                    ? null // locked — not tappable
                    : () => _handleHabitDayTap(context, store, habit, date),
                child: SizedBox(
                  height: 26,
                  child: Center(child: _CircleDayDot(type: type, isToday: isToday, size: 22)),
                ),
              ),
            ]),
          );
        })),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  YEAR TAB
// ═══════════════════════════════════════════════════════════

class YearTab extends StatelessWidget {
  final HabitStore store;
  const YearTab({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppTheme.bg,
          body: SafeArea(
            child: _ResponsiveWrapper(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _TabHeader(title: store.text('year'), onAdd: () => showCreateDialog(context, store)),
                Expanded(
                  child: store.habits.isEmpty
                      ? Center(child: Text(store.text('noHabitsYet'),
                      style: TextStyle(color: AppTheme.textSecondary)))
                      : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    itemCount: store.habits.length,
                    itemBuilder: (_, i) => RepaintBoundary(
                      child: _YearCard(habit: store.habits[i], store: store),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}

class _YearCard extends StatelessWidget {
  final Habit habit;
  final HabitStore store;
  const _YearCard({required this.habit, required this.store});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final year = now.year;
    final allDays = List.generate(
      DateTime(year, 12, 31).difference(DateTime(year, 1, 1)).inDays + 1,
          (i) => DateTime(year, 1, 1).add(Duration(days: i)),
    );
    final totalScheduled = allDays.where((d) => habit.isScheduledOn(d) && !_isFutureDate(d)).length;
    final completed = habit.completions.entries.where((e) {
      final d = DateTime.tryParse(e.key);
      return d != null && d.year == year && e.value >= habit.completionsPerDay;
    }).length;
    final pct = totalScheduled > 0
        ? '${((completed / totalScheduled) * 100).round()}%'
        : '0%';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder, width: 1.0),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('Year',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14,
                  color: AppTheme.textPrimary)),
          const Spacer(),
          Text(pct,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13,
                  color: AppTheme.textSecondary)),
          const SizedBox(width: 8),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => showHabitActions(context, habit, store),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(Icons.more_horiz, color: AppTheme.textTertiary, size: 18),
            ),
          ),
        ]),
        const SizedBox(height: 10),
        _YearDotGrid(habit: habit, store: store, year: year),
      ]),
    );
  }
}

/// Year dot grid — animated fill from Jan 1 → today, one scheduled day at a time.
class _YearDotGrid extends StatefulWidget {
  final Habit habit;
  final HabitStore store;
  final int year;
  const _YearDotGrid({required this.habit, required this.store, required this.year});

  @override
  State<_YearDotGrid> createState() => _YearDotGridState();
}

class _YearDotGridState extends State<_YearDotGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    // Count only scheduled past days — these are the ones we animate through
    final scheduledCount = _countScheduledPastDays();
    _ctrl = AnimationController(
      vsync: this,
      // ~2ms per dot so it feels fast but still visible; min 400ms, max 1200ms
      duration: Duration(milliseconds: (scheduledCount * 6).clamp(2000, 2500)),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(_YearDotGrid old) {
    super.didUpdateWidget(old);
    if (old.habit.id != widget.habit.id || old.year != widget.year) {
      final scheduledCount = _countScheduledPastDays();
      _ctrl.duration = Duration(milliseconds: (scheduledCount * 6).clamp(2000, 2500));
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  int _countScheduledPastDays() {
    final now = DateTime.now();
    final start = DateTime(widget.year, 1, 1);
    final totalDays = DateTime(widget.year, 12, 31).difference(start).inDays + 1;
    int count = 0;
    for (int i = 0; i < totalDays; i++) {
      final d = start.add(Duration(days: i));
      if (!_isFutureDate(d) && widget.habit.isScheduledOn(d)) count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final now = DateTime.now();
        final start = DateTime(widget.year, 1, 1);
        final totalDays = DateTime(widget.year, 12, 31).difference(start).inDays + 1;
        final startPad = start.weekday - 1;
        final totalCells = ((startPad + totalDays) / 7).ceil() * 7;
        final weeks = totalCells ~/ 7;
        const gap = 2.0;

        // How many scheduled past days should be revealed so far
        final scheduledCount = _countScheduledPastDays();
        final revealedCount = (_anim.value * scheduledCount).round();

        // Build cell data — track scheduled past days seen so far
        final List<_CT> types = List.filled(totalCells, _CT.gray);
        final List<DateTime?> dates = List.filled(totalCells, null);
        int scheduledSeen = 0;

        for (int i = 0; i < totalCells; i++) {
          final dayOffset = i - startPad;
          if (dayOffset < 0 || dayOffset >= totalDays) continue;
          final d = start.add(Duration(days: dayOffset));
          dates[i] = d;
          final sched = widget.habit.isScheduledOn(d);
          final done = widget.habit.isCompletedOn(d);
          final isFuture = _isFutureDate(d);

          if (!sched) {
            types[i] = _CT.gray; // not scheduled — always show as gray
          } else if (isFuture) {
            types[i] = _CT.empty; // future — always show as empty
          } else {
            // Scheduled past day — only reveal if within our animated count
            scheduledSeen++;
            if (scheduledSeen <= revealedCount) {
              types[i] = done ? _CT.done : _CT.undone;
            } else {
              // Not yet revealed — show as undone (scheduled but not filled yet)
              types[i] = _CT.undone;
            }
          }
        }

        return LayoutBuilder(builder: (_, box) {
          final d = ((box.maxWidth - gap * (weeks - 1)) / weeks).clamp(3.0, 11.0);
          final rowH = d + gap;

          return SizedBox(
            width: box.maxWidth,
            height: 7 * d + 6 * gap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(7, (dow) {
                return SizedBox(
                  height: dow < 6 ? rowH : d,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: List.generate(weeks, (wIdx) {
                      final cellIdx = wIdx * 7 + dow;
                      final type = types[cellIdx];
                      final cellDate = dates[cellIdx];
                      final isToday = cellDate != null && _isSameDate(cellDate, now);
                      return GestureDetector(
                        onTap: () {
                          if (cellDate == null) return;
                          _handleHabitDayTap(context, widget.store, widget.habit, cellDate);
                        },
                        child: Container(
                          width: d,
                          height: d,
                          margin: EdgeInsets.only(right: wIdx < weeks - 1 ? gap : 0),
                          child: _CircleDayDot(
                            type: type,
                            isToday: isToday,
                            size: d,
                            borderWidth: type == _CT.undone ? 0.8 : 0,
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          );
        });
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  STATISTICS TAB
// ═══════════════════════════════════════════════════════════

class StatisticsTab extends StatefulWidget {
  final HabitStore store;
  const StatisticsTab({super.key, required this.store});

  @override
  State<StatisticsTab> createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {
  int _selIdx = 0;
  int _year = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final habits = widget.store.habits;
    if (habits.isEmpty) {
      return Scaffold(
        backgroundColor: AppTheme.bg,
        body: SafeArea(
          child: _ResponsiveWrapper(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _TabHeader(title: widget.store.text('statistics')),
              Expanded(
                  child: Center(child: Text(widget.store.text('noHabitsYet'),
                      style: TextStyle(color: AppTheme.textSecondary)))),
            ]),
          ),
        ),
      );
    }
    if (_selIdx >= habits.length) _selIdx = 0;
    final h = habits[_selIdx];
    final done = h.completedDaysInYear(_year);
    final rate = h.completionRateInYear(_year);
    final monthly = h.monthlyCompletions(_year);

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: _ResponsiveWrapper(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            children: [
              // ... (Header and Habit Selector Card remain the same)
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
                child: Text(widget.store.text('statistics'),
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary)),
              ),
              Builder(
                  builder: (cardContext) { // cardContext gives us the exact location of this card
                    return _Card(
                      child: GestureDetector(
                        onTap: () {
                          // 1. Get the exact position of this specific Card on the screen
                          final RenderBox box = cardContext.findRenderObject() as RenderBox;
                          final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

                          // 2. Calculate the position (Pushes the menu to start at the bottom of the card)
                          final RelativeRect position = RelativeRect.fromRect(
                            Rect.fromPoints(
                              box.localToGlobal(box.size.bottomLeft(Offset.zero), ancestor: overlay),
                              box.localToGlobal(box.size.bottomRight(Offset.zero), ancestor: overlay),
                            ),
                            Offset.zero & overlay.size,
                          );

                          // 3. Show the menu
                          showMenu<int>(
                            context: context,
                            position: position,
                            color: AppTheme.surface,
                            elevation: 4,
                            constraints: BoxConstraints(
                              minWidth: box.size.width, // Makes menu match the width of the selector
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            items: habits.asMap().entries.map((e) {
                              final bool isSelected = e.key == _selIdx;
                              return PopupMenuItem<int>(
                                value: e.key,
                                child: Row(
                                  children: [
                                    _HabitIconBox(iconData: e.value.iconData, size: 24),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        e.value.title,
                                        style: TextStyle(
                                          color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(Icons.check, size: 16, color: AppTheme.textPrimary),
                                  ],
                                ),
                              );
                            }).toList(),
                          ).then((i) {
                            if (i != null) setState(() => _selIdx = i);
                          });
                        },
                        child: Container(
                          color: Colors.transparent, // Ensures entire card is tappable
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              _HabitIconBox(iconData: h.iconData),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  h.title,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary, size: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              ),
              const SizedBox(height: 10),

              // YEAR GRID CARD
              _Card(child: Column(children: [
                Row(children: [
                  GestureDetector(
                      onTap: () => setState(() => _year--),
                      child: Icon(Icons.chevron_left, size: 22,
                          color: AppTheme.textSecondary)),
                  Expanded(child: Text('$_year',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
                  GestureDetector(
                      onTap: () => setState(() => _year++),
                      child: Icon(Icons.chevron_right, size: 22,
                          color: AppTheme.textSecondary)),
                ]),
                const SizedBox(height: 10),
                _YearDotGrid(habit: h, store: widget.store, year: _year),
              ])),
              const SizedBox(height: 10),

              // 1. ANIMATED MINI STATS (Completed Days & Rate)
              Row(children: [
                Expanded(child: _AnimatedStatMini(
                    key: ValueKey('done_${h.id}_$_year'),
                    iconData: Icons.tag,
                    label: widget.store.text('completedDays'),
                    endValue: done.toDouble(),
                    formatter: (v) => '${v.toInt()}')),
                const SizedBox(width: 10),
                Expanded(child: _AnimatedStatMini(
                    key: ValueKey('rate_${h.id}_$_year'),
                    iconData: Icons.percent,
                    label: widget.store.text('completionRate'),
                    endValue: rate,
                    formatter: (v) => '${(v * 100).round()}%')),
              ]),
              const SizedBox(height: 10),

              // 2. ANIMATED MONTHLY CHART (The "Pop" effect from your image)
              // ANIMATED MONTHLY CHART
              _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(widget.store.text('monthlyCompletions'),
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const Spacer(),
                  _IconSq(Icons.show_chart),
                ]),
                const SizedBox(height: 12),
                SizedBox(
                  height: 110,
                  child: TweenAnimationBuilder<double>(
                    key: ValueKey('chart_${h.id}_$_year'),
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (context, animValue, child) {
                      return _SplineChart(
                        data: monthly.map((v) => v.toDouble() * animValue).toList(),
                        labels: AppStrings.months(widget.store.languageCode),
                      );
                    },
                  ),
                ),
              ])),
              const SizedBox(height: 10),

              // 3. ANIMATED DAILY STREAKS
              Row(children: [
                Expanded(child: _StreakCard(
                    iconData: Icons.local_fire_department_outlined,
                    label: '${widget.store.text('currentDailyStreak')}\n',
                    value: h.currentDailyStreak())),
                const SizedBox(width: 10),
                Expanded(child: _StreakCard(
                    iconData: Icons.emoji_events_outlined,
                    label: '${widget.store.text('bestDailyStreak')}\n',
                    value: h.bestDailyStreak())),
              ]),
              const SizedBox(height: 10),

              // 4. ANIMATED WEEKLY STREAKS
              Row(children: [
                Expanded(child: _StreakCard(
                    iconData: Icons.star_outline,
                    label: '${widget.store.text('currentWeeklyStreak')}\n',
                    value: h.currentWeeklyStreak())),
                const SizedBox(width: 10),
                Expanded(child: _StreakCard(
                    iconData: Icons.military_tech_outlined,
                    label: '${widget.store.text('bestWeeklyStreak')}\n',
                    value: h.bestWeeklyStreak())),
              ]),

              // ... (Notes section remains the same)
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// Updated _StreakCard with internal animation
class _StreakCard extends StatefulWidget {
  final IconData iconData;
  final String label;
  final int value;
  const _StreakCard({super.key, required this.iconData, required this.label, required this.value});
  @override
  State<_StreakCard> createState() => _StreakCardState();
}
class _StreakCardState extends State<_StreakCard> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700));
  late final Animation<double> _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
  @override void initState() { super.initState(); _ctrl.forward(); }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => _Card(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _IconSq(widget.iconData),
        const SizedBox(width: 8),
        Expanded(child: Text(widget.label,
            style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.3))),
      ]),
      const SizedBox(height: 10),
      AnimatedBuilder(animation: _anim, builder: (_, __) =>
          Text('${(_anim.value * widget.value).toInt()}',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700))),
    ]),
  );
}

class _AnimatedStatMini extends StatefulWidget {
  final IconData iconData;
  final String label;
  final double endValue;
  final String Function(double) formatter;
  const _AnimatedStatMini({super.key, required this.iconData, required this.label,
    required this.endValue, required this.formatter});
  @override
  State<_AnimatedStatMini> createState() => _AnimatedStatMiniState();
}
class _AnimatedStatMiniState extends State<_AnimatedStatMini> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700));
  late final Animation<double> _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
  @override void initState() { super.initState(); _ctrl.forward(); }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => _Card(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _IconSq(widget.iconData),
        const SizedBox(width: 8),
        Expanded(child: Text(widget.label,
            style: TextStyle(fontSize: 11, color: AppTheme.textSecondary))),
      ]),
      const SizedBox(height: 10),
      AnimatedBuilder(animation: _anim, builder: (_, __) =>
          Text(widget.formatter(_anim.value * widget.endValue),
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700))),
    ]),
  );
}

void _launchUrl(String url) async {
  final uri = Uri.parse(url);
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {}
}

// ═══════════════════════════════════════════════════════════
//  SETTINGS TAB
// ═══════════════════════════════════════════════════════════

class SettingsTab extends StatelessWidget {
  final HabitStore store;
  const SettingsTab({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => Scaffold(
        backgroundColor: AppTheme.bg,
        body: SafeArea(
          child: _ResponsiveWrapper(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _TabHeader(title: store.text('settings')),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  children: [
                    _SettingsTile(
                      icon: Icons.notifications_outlined,
                      title: store.text('notifications'),
                      subtitle: store.text('notificationsDescription'),
                      onTap: () => Navigator.push(context,
                          _SlideRoute(child: _NotificationsSettingsPage(store: store))),
                    ),
                    _SettingsTile(
                      icon: Icons.palette_outlined,
                      title: store.text('theme'),
                      subtitle: store.text('themeDescription'),
                      onTap: () => Navigator.push(context,
                          _SlideRoute(child: _ThemeSettingsPage(store: store))),
                    ),
                    _SettingsTile(
                      icon: Icons.language_outlined,
                      title: store.text('language'),
                      subtitle: store.text('languageDescription'),
                      onTap: () => Navigator.push(context,
                          _SlideRoute(child: _LanguageSettingsPage(store: store))),
                    ),
                    _SettingsTile(
                      icon: Icons.archive_outlined,
                      title: store.text('archive'),
                      subtitle: store.text('archiveDescription'),
                      onTap: () => Navigator.push(context,
                          _SlideRoute(child: _ArchiveSettingsPage(store: store))),
                    ),
                    _SettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      title: store.text('privacyPolicy'),
                      subtitle: store.text('privacyDescription'),
                      onTap: () => Navigator.push(context,
                          _SlideRoute(child: _PrivacyPolicyPage(store: store))),
                    ),
                    _SettingsTile(
                      icon: Icons.language_outlined,
                      title: 'Website',
                      subtitle: 'Visit doingnow.lovable.app',
                      onTap: () => _launchUrl('https://doingnow.lovable.app'),
                    ),
                    _SettingsTile(
                      icon: Icons.feedback_outlined,
                      title: 'Feedback',
                      subtitle: 'Send us your thoughts',
                      onTap: () => _launchUrl(
                          'https://doingnow.lovable.app/contact'),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _NotificationsSettingsPage extends StatelessWidget {
  final HabitStore store;
  const _NotificationsSettingsPage({required this.store});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (_, __) => _SettingsScaffold(
      title: store.text('notifications'),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Battery optimization banner — critical for killed-app notifications
          if (Platform.isAndroid)
            GestureDetector(
              onTap: () => NotificationService.instance.requestBatteryOptimizationAccess(),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Row(children: [
                  Icon(Icons.battery_saver_outlined, size: 18, color: AppTheme.textPrimary),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Background activity',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text('Set doingnow to Unrestricted so reminders fire when the app is closed.',
                        style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.4)),
                  ])),
                  Icon(Icons.chevron_right, size: 16, color: AppTheme.textTertiary),
                ]),
              ),
            ),

          // Master toggle
          _Card(
            child: Row(
              children: [
                _IconSq(Icons.notifications_outlined),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.text('notifications'),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        store.text('notificationsDescription'),
                        style: TextStyle(
                            fontSize: 12, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
                _ThemedSwitch(
                  value: store.notificationsEnabled,
                  onChanged: store.updateNotificationsEnabled,
                ),
              ],
            ),
          ),
          // Per-habit toggles (only shown when master is on)
          if (store.notificationsEnabled) ...[
            const SizedBox(height: 4),
            ...store.habits.map((habit) => _Card(
              child: Row(
                children: [
                  _HabitIconBox(iconData: habit.iconData, size: 36),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(habit.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14)),
                        Text(
                          '${habit.reminder.time.hour.toString().padLeft(2, '0')}:${habit.reminder.time.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  _ThemedSwitch(
                    value: habit.notificationEnabled,
                    onChanged: (v) {
                      habit.notificationEnabled = v;
                      store.updateHabit(habit);
                    },
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    ),
  );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => _Card(
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      leading: _IconSq(icon),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(subtitle,
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      ),
      trailing: Icon(Icons.chevron_right, color: AppTheme.textSecondary),
      onTap: onTap,
    ),
  );
}

class _SettingsScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  const _SettingsScaffold({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _globalStore,
      builder: (_, __) => Scaffold(
        backgroundColor: AppTheme.bg,
        appBar: AppBar(
          backgroundColor: AppTheme.bg,
          elevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(title,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              )),
        ),
        body: _ResponsiveWrapper(child: child),
      ),
    );
  }
}

class _ThemeSettingsPage extends StatelessWidget {
  final HabitStore store;
  const _ThemeSettingsPage({required this.store});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (_, __) {
      final entries = [
        (AppThemeModePreference.light, store.text('light')),
        (AppThemeModePreference.dark, store.text('dark')),
      ];
      return _SettingsScaffold(
        title: store.text('theme'),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          itemCount: entries.length,
          separatorBuilder: (_, __) => Divider(color: AppTheme.divider, height: 1),
          itemBuilder: (_, index) {
            final entry = entries[index];
            final selected = store.themePreference == entry.$1;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(entry.$2,
                  style: TextStyle(fontSize: 16, color: AppTheme.textPrimary)),
              trailing: selected
                  ? Container(
                width: 18, height: 18,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF7A7A73),
                ),
              ) : null,
              onTap: () => store.updateThemePreference(entry.$1),
            );
          },
        ),
      );
    },
  );
}

class _LanguageSettingsPage extends StatelessWidget {
  final HabitStore store;
  const _LanguageSettingsPage({required this.store});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (_, __) => _SettingsScaffold(
      title: store.text('language'),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: kAppLanguages.length,
        separatorBuilder: (_, __) => Divider(color: AppTheme.divider, height: 1),
        itemBuilder: (_, index) {
          final language = kAppLanguages[index];
          final selected = store.languageCode == language.code;
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Text(language.flag, style: const TextStyle(fontSize: 22)),
            title: Text(language.name,
                style: TextStyle(fontSize: 16, color: AppTheme.textPrimary)),
            trailing: selected
                ? Container(
              width: 18, height: 18,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF7A7A73),
              ),
            ) : null,
            onTap: () => store.updateLanguage(language.code),
          );
        },
      ),
    ),
  );
}

class _ArchiveSettingsPage extends StatelessWidget {
  final HabitStore store;
  const _ArchiveSettingsPage({required this.store});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (_, __) => _SettingsScaffold(
      title: store.text('archive'),
      child: store.archivedHabits.isEmpty
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.archive_outlined, color: AppTheme.textTertiary, size: 44),
            const SizedBox(height: 12),
            Text(store.text('noArchivedHabits'),
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 15)),
            const SizedBox(height: 6),
            Text(store.text('emptyArchiveHint'),
                style: TextStyle(color: AppTheme.textTertiary, fontSize: 12)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: store.archivedHabits.length,
        itemBuilder: (_, index) {
          final habit = store.archivedHabits[index];
          return _Card(
            child: Row(
              children: [
                _HabitIconBox(iconData: habit.iconData),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(habit.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      if (habit.category.isNotEmpty)
                        Text(habit.category,
                            style: TextStyle(
                                color: AppTheme.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => store.restoreHabit(habit.id),
                  icon: Icon(Icons.restore_outlined, color: AppTheme.textPrimary),
                  tooltip: store.text('restore'),
                ),
                IconButton(
                  onPressed: () => _confirmDeleteHabit(context, store, habit),
                  icon: Icon(Icons.delete_outline, color: AppTheme.danger),
                  tooltip: store.text('delete'),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

class _PrivacyPolicyPage extends StatelessWidget {
  final HabitStore store;
  const _PrivacyPolicyPage({required this.store});

  @override
  Widget build(BuildContext context) => _SettingsScaffold(
    title: store.text('privacyPolicy'),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Column(
        children: [
          const Spacer(),
          Text(
            store.text('privacyText'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 15,
              height: 1.6,
            ),
          ),
          const Spacer(),
          Text(
            store.text('versionClean'),
            style: TextStyle(
              color: AppTheme.textTertiary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════
//  SHARED SMALL WIDGETS
// ═══════════════════════════════════════════════════════════

class _TabHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onAdd;
  const _TabHeader({required this.title, this.onAdd});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
    child: Row(children: [
      Text(title,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary)),
      const Spacer(),
      if (onAdd != null)
        GestureDetector(
          onTap: onAdd,
          child: Icon(Icons.add, size: 26, color: AppTheme.textPrimary),
        ),
    ]),
  );
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: AppTheme.cardSurface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppTheme.cardBorder, width: 1.0),
    ),
    child: child,
  );
}

class _HabitHeader extends StatelessWidget {
  final Habit habit;
  final HabitStore store;
  final String? sub;
  const _HabitHeader({required this.habit, required this.store, this.sub});

  @override
  Widget build(BuildContext context) => Row(children: [
    _HabitIconBox(iconData: habit.iconData),
    const SizedBox(width: 10),
    Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(habit.title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        if (sub != null)
          Text(sub!,
              style: TextStyle(
                  fontSize: 11, color: AppTheme.textSecondary)),
      ]),
    ),
    GestureDetector(
      onTap: () => showHabitActions(context, habit, store),
      child: Icon(Icons.more_vert,
          size: 18, color: AppTheme.textSecondary),
    ),
  ]);
}

class _HabitIconBox extends StatelessWidget {
  final IconData iconData;
  final double size;
  const _HabitIconBox({required this.iconData, this.size = 38});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: AppTheme.surface,
      shape: BoxShape.circle,
      border: Border.all(color: AppTheme.border, width: 1),
    ),
    child: Center(
      child: Icon(iconData, size: size * 0.52, color: AppTheme.textPrimary),
    ),
  );
}

class _IconSq extends StatelessWidget {
  final IconData icon;
  const _IconSq(this.icon);

  @override
  Widget build(BuildContext context) => Container(
    width: 28,
    height: 28,
    decoration: BoxDecoration(
      color: AppTheme.surface,
      shape: BoxShape.circle,
      border: Border.all(color: AppTheme.border, width: 1),
    ),
    child: Center(child: Icon(icon, size: 14, color: AppTheme.textPrimary)),
  );
}

// Cell types
enum _CT { done, undone, gray, empty }

class _DayCell extends StatelessWidget {
  final _CT type;
  final bool isToday;
  const _DayCell({required this.type, this.isToday = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _CircleDayDot(
        type: type,
        isToday: isToday,
        size: 16,
      ),
    );
  }
}

class _CircleDayDot extends StatelessWidget {
  final _CT type;
  final bool isToday;
  final double size;
  final double borderWidth;

  const _CircleDayDot({
    required this.type,
    this.isToday = false,
    required this.size,
    this.borderWidth = 1.1,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color borderColor;
    Widget? inner;

    switch (type) {
      case _CT.done:
        bg = AppTheme.doneDot;
        borderColor = AppTheme.doneDot;
        inner = null;
        break;

      case _CT.undone:
      // Past incomplete — transparent fill with theme-specific border
        bg = Colors.transparent;

        final isDark =
            Theme.of(context).brightness == Brightness.dark;

        borderColor = isToday
            ? AppTheme.textPrimary
            : (isDark
            ? const Color(0xFF222222) // Dark theme
            : const Color(0xFFCACACA)); // Light theme

        break;

      case _CT.empty:
      // Upcoming (future) days — swapped: was inactive color
        bg = AppTheme.upcomingDot;
        borderColor = AppTheme.upcomingDot;
        break;

      case _CT.gray:
      // Inactive (not scheduled) — swapped: was upcoming color
        bg = AppTheme.inactiveDot;
        borderColor = AppTheme.inactiveDot;
        break;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: borderWidth > 0
            ? Border.all(
          color: borderColor,
          width: isToday ? borderWidth + 0.7 : borderWidth,
        )
            : null,
      ),
      child: inner != null ? Center(child: inner) : null,
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  SPLINE CHART
// ═══════════════════════════════════════════════════════════

class _SplineChart extends StatefulWidget {
  final List<double> data;
  final List<String> labels;
  const _SplineChart({required this.data, required this.labels});

  @override
  State<_SplineChart> createState() => _SplineChartState();
}

class _SplineChartState extends State<_SplineChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(_SplineChart old) {
    super.didUpdateWidget(old);
    if (old.data != widget.data) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _animation,
    builder: (_, __) => CustomPaint(
      size: const Size(double.infinity, 110),
      painter: _SplinePainter(
        data: widget.data,
        labels: widget.labels,
        animationValue: _animation.value,
      ),
    ),
  );
}

class _SplinePainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final double animationValue;

  _SplinePainter({
    required this.data,
    required this.labels,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxV = data.fold(0.0, (a, b) => a > b ? a : b);
    final chartMax = maxV <= 0 ? 5.0 : maxV * 1.25;
    const labelH = 16.0;
    final chartH = size.height - labelH;
    final n = data.length;
    final stepX = size.width / (n - 1);

    // How many points are "active" — reveals one by one
    // animationValue 0→1 maps across all n points
    final double progress = animationValue * (n - 1); // e.g. 0 → 11 for 12 months
    final int fullPoints = progress.floor();           // fully revealed points
    final double partial = progress - fullPoints;      // 0→1 fraction into next point

    // Grid
    final gridPaint = Paint()
      ..color = AppTheme.borderLight
      ..strokeWidth = 0.6;
    for (int i = 0; i <= 4; i++) {
      final y = chartH - chartH * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Build all points at full height — but only reveal up to current progress
    final allPts = List.generate(n, (i) =>
        Offset(i * stepX, chartH - (data[i] / chartMax) * chartH));

    // Visible points: fully revealed ones + interpolated next point
    final List<Offset> pts = [];
    for (int i = 0; i <= fullPoints && i < n; i++) {
      pts.add(allPts[i]);
    }
    // Add the partially revealed next point (interpolated X and Y from previous)
    if (fullPoints + 1 < n) {
      final from = allPts[fullPoints];
      final to = allPts[fullPoints + 1];
      pts.add(Offset(
        lerpDouble(from.dx, to.dx, partial)!,
        lerpDouble(from.dy, to.dy, partial)!,
      ));
    }

    if (pts.length < 2) {
      // Only one point visible — just draw the dot
      _drawDot(canvas, pts.first);
      return;
    }

    Path buildSpline(List<Offset> points) {
      final p = Path()..moveTo(points[0].dx, points[0].dy);
      for (int i = 0; i < points.length - 1; i++) {
        final cp1 = Offset((points[i].dx + points[i + 1].dx) / 2, points[i].dy);
        final cp2 = Offset((points[i].dx + points[i + 1].dx) / 2, points[i + 1].dy);
        p.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i + 1].dx, points[i + 1].dy);
      }
      return p;
    }

    final splinePath = buildSpline(pts);
    final lastPt = pts.last;

    // Fill — close path down to baseline only up to current X
    final fillPath = Path.from(splinePath);
    fillPath.lineTo(lastPt.dx, chartH);
    fillPath.lineTo(0, chartH);
    fillPath.close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          colors: [Colors.black.withOpacity(0.11), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, size.width, chartH))
        ..style = PaintingStyle.fill,
    );

    // Stroke
    canvas.drawPath(
      splinePath,
      Paint()
        ..color = AppTheme.textPrimary
        ..strokeWidth = 1.8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Dots — only on fully revealed points (not the partial leading edge)
    for (int i = 0; i < pts.length - 1; i++) {
      _drawDot(canvas, pts[i]);
    }
    // Also draw dot on the last partial point so the leading edge has a dot
    _drawDot(canvas, lastPt);

    // Labels
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < labels.length; i++) {
      tp.text = TextSpan(
        text: labels[i],
        style: TextStyle(fontSize: 8, color: AppTheme.textSecondary),
      );
      tp.layout();
      tp.paint(canvas, Offset(i * stepX - tp.width / 2, chartH + 4));
    }
  }

  void _drawDot(Canvas canvas, Offset p) {
    canvas.drawCircle(p, 3, Paint()..color = Colors.white..style = PaintingStyle.fill);
    canvas.drawCircle(p, 3, Paint()
      ..color = AppTheme.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4);
  }

  @override
  bool shouldRepaint(_SplinePainter old) =>
      old.animationValue != animationValue ||
          old.data != data ||
          old.labels != labels;
}

// ═══════════════════════════════════════════════════════════
//  HABIT ACTIONS BOTTOM SHEET
// ═══════════════════════════════════════════════════════════

void showHabitActions(BuildContext context, Habit habit, HabitStore store) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (_) => Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 4),
          Text(habit.title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,
                  color: AppTheme.textSecondary),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Divider(color: AppTheme.cardBorder, height: 1),
          _ATile(icon: Icons.calendar_month_outlined, label: store.text('calendar'),
              onTap: () { Navigator.pop(context); _showCal(context, habit, store); }),
          _ATile(icon: Icons.edit_outlined, label: store.text('edit'),
              onTap: () { Navigator.pop(context); showCreateDialog(context, store, existing: habit); }),
          _ATile(icon: Icons.share_outlined, label: store.text('share'),
              onTap: () { Navigator.pop(context); _showShareSheet(context, store, habit); }),
          _ATile(icon: Icons.archive_outlined, label: store.text('archive'),
              onTap: () { Navigator.pop(context); store.archiveHabit(habit.id); }),
          const SizedBox(height: 4),
        ]),
      ),
    ),
  );
}

Widget _dragHandle() => Container(
  width: 36, height: 4,
  margin: const EdgeInsets.only(bottom: 10),
  decoration: BoxDecoration(
      color: AppTheme.gray, borderRadius: BorderRadius.circular(2)),
);

class _ATile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ATile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: AppTheme.textPrimary, size: 21),
    title: Text(label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
    trailing: const SizedBox.shrink(),
    onTap: onTap,
    visualDensity: VisualDensity.compact,
  );
}

// ═══════════════════════════════════════════════════════════
//  CALENDAR BOTTOM SHEET
// ═══════════════════════════════════════════════════════════

void _showCal(BuildContext context, Habit habit, HabitStore store) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (_) => Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: _CalSheet(habit: habit, store: store),
    ),
  );
}

class _CalSheet extends StatefulWidget {
  final Habit habit;
  final HabitStore store;
  const _CalSheet({required this.habit, required this.store});

  @override
  State<_CalSheet> createState() => _CalSheetState();
}

class _CalSheetState extends State<_CalSheet> {
  late DateTime _month;

  static const _monthNames = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December'
  ];
  static const _dayLabels = ['M','T','W','T','F','S','S'];
  static const _fullDayNames = [
    'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'
  ];

  @override
  void initState() {
    super.initState();
    _month = DateTime(DateTime.now().year, DateTime.now().month);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final firstOffset = DateTime(_month.year, _month.month, 1).weekday - 1;
    final totalCells = ((firstOffset + daysInMonth) / 7).ceil() * 7;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Month navigator
        Row(children: [
          GestureDetector(
              onTap: () => setState(
                      () => _month = DateTime(_month.year, _month.month - 1)),
              child: Icon(Icons.chevron_left, color: AppTheme.textPrimary, size: 20)),
          Expanded(child: Text(
              '${_monthNames[_month.month - 1]} ${_month.year}',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13,
                  color: AppTheme.textPrimary))),
          GestureDetector(
              onTap: () => setState(
                      () => _month = DateTime(_month.year, _month.month + 1)),
              child: Icon(Icons.chevron_right, color: AppTheme.textPrimary, size: 20)),
        ]),
        const SizedBox(height: 14),
        // Two-column layout: left = date info, right = grid
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // LEFT: month abbr / full day name / large date number
          SizedBox(width: 76, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_monthNames[_month.month - 1].substring(0, 3),
                  style: TextStyle(fontSize: 11,
                      color: AppTheme.textSecondary, fontWeight: FontWeight.w400)),
              Text(_fullDayNames[now.weekday - 1],
                  style: TextStyle(fontSize: 12,
                      color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(now.day.toString().padLeft(2, '0'),
                  style: TextStyle(fontSize: 40, height: 1.0,
                      fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            ],
          )),
          const SizedBox(width: 10),
          // RIGHT: weekday labels + grid
          Expanded(child: Column(children: [
            Row(children: _dayLabels.map((d) => Expanded(
              child: Text(d, textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 9,
                      color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
            )).toList()),
            const SizedBox(height: 4),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 1,
                  childAspectRatio: 1.1),
              itemCount: totalCells,
              itemBuilder: (_, i) {
                final dayNum = i - firstOffset + 1;
                final isOutside = dayNum < 1 || dayNum > daysInMonth;
                if (isOutside) {
                  final label = dayNum < 1
                      ? '${DateTime(_month.year, _month.month, 0).day + dayNum}'
                      : '${dayNum - daysInMonth}';
                  return Center(child: Text(label,
                      style: TextStyle(fontSize: 10,
                          color: AppTheme.textTertiary.withOpacity(0.3))));
                }
                final date = DateTime(_month.year, _month.month, dayNum);
                final sched = widget.habit.isScheduledOn(date);
                final done = widget.habit.isCompletedOn(date);
                final isToday = _isSameDate(date, now);
                final isFuture = _isFutureDate(date);

                return GestureDetector(
                  onTap: () {
                    _handleHabitDayTap(context, widget.store, widget.habit, date);
                    setState(() {});
                  },
                  child: Center(
                    child: Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done ? const Color(0xFF1C1C1C) : Colors.transparent,
                        border: isToday && !done
                            ? Border.all(color: AppTheme.textPrimary, width: 1.5)
                            : null,
                      ),
                      child: Center(child: Text('$dayNum',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                            color: done ? Colors.white
                                : !sched || isFuture ? AppTheme.textTertiary
                                : AppTheme.textPrimary,
                          ))),
                    ),
                  ),
                );
              },
            ),
          ])),
        ]),
      ]),
    );
  }
}


// ═══════════════════════════════════════════════════════════
//  CREATE / EDIT HABIT SHEET
// ═══════════════════════════════════════════════════════════

void showCreateDialog(BuildContext context, HabitStore store, {Habit? existing}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppTheme.surface,
    constraints: const BoxConstraints(maxWidth: 680),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
    builder: (_) => _CreateSheet(store: store, existing: existing),
  );
}

class _CreateSheet extends StatefulWidget {
  final HabitStore store;
  final Habit? existing;
  const _CreateSheet({required this.store, this.existing});

  @override
  State<_CreateSheet> createState() => _CreateSheetState();
}

class _CreateSheetState extends State<_CreateSheet> {
  late TextEditingController _title, _desc, _cat;
  late int _iconCP, _completions;
  late Set<int> _days;
  late TimeOfDay _time;
  late StreakType _streakType;
  late bool _showStreak;
  late bool _notificationEnabled;
  int _iconTab = 0;

  static const _cats = [
    'Home', 'Work', 'School', 'College', 'Morning', 'Evening',
    'Afternoon', 'Night', 'Workout', 'Health', 'Finance', 'Mindfulness',
  ];

  @override
  void initState() {
    super.initState();
    final h = widget.existing;
    _title = TextEditingController(text: h?.title ?? '');
    _desc = TextEditingController(text: h?.description ?? '');
    _cat = TextEditingController(text: h?.category ?? '');
    _iconCP = h?.iconCodePoint ?? kDefaultHabitIcon.codePoint;
    _completions = h?.completionsPerDay ?? 1;
    _days = Set.from(h?.reminder.days ?? {});
    _time = h?.reminder.time ?? const TimeOfDay(hour: 12, minute: 0);
    _streakType = h?.streakType ?? StreakType.daily;
    _showStreak = h?.showStreak ?? true;
    _notificationEnabled = h?.notificationEnabled ?? false;
  }

  @override
  void dispose() {
    _title.dispose(); _desc.dispose(); _cat.dispose();
    super.dispose();
  }

  void _save() {
    final h = Habit(
      id: widget.existing?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: _title.text.trim(),
      description: _desc.text.trim(),
      iconCodePoint: _iconCP,
      category: _cat.text,
      completionsPerDay: _completions,
      reminder: HabitReminder(days: Set.from(_days), time: _time),
      streakType: _streakType,
      showStreak: _showStreak,
      notificationEnabled: _notificationEnabled,
      completions: widget.existing?.completions,
    );
    if (widget.existing == null) widget.store.addHabit(h);
    else widget.store.updateHabit(h);
    if (_notificationEnabled && !widget.store.notificationsEnabled) {
      widget.store.updateNotificationsEnabled(true);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final curIcon = _iconFromCP(_iconCP);

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.97,
      expand: false,
      builder: (_, scroll) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(children: [
          const SizedBox(height: 12),
          _dragHandle(),
          Text(widget.store.text(widget.existing == null ? 'createHabit' : 'editHabit'),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
          Divider(height: 16, color: AppTheme.divider),
          Expanded(
            child: ListView(
              controller: scroll,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              children: [
                _FF(controller: _title, hint: widget.store.text('title')),
                const SizedBox(height: 10),
                _FF(controller: _desc, hint: widget.store.text('description'), maxLines: 2),
                const SizedBox(height: 14),

                // Selected icon preview
                Row(children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.cardBorder, width: 1.0),
                    ),
                    child: Center(child: Icon(curIcon, size: 22,
                        color: AppTheme.textPrimary)),
                  ),
                  const SizedBox(width: 10),
                  Text(widget.store.text('pickIcon'),
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13,
                          color: AppTheme.textSecondary)),
                ]),
                const SizedBox(height: 8),

                // Icon category tabs
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: kIconCategories.length,
                    itemBuilder: (_, i) {
                      final active = _iconTab == i;
                      return GestureDetector(
                        onTap: () => setState(() => _iconTab = i),
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.transparent, // Fixed to transparent
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: active
                                    ? AppTheme.textPrimary
                                    : AppTheme.cardBorder,
                                width: active ? 1.5 : 1.0), // Slightly thicker when active
                          ),
                          child: Text(kIconCategories[i].name,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  // Adapts beautifully to Dark/Light mode
                                  color: AppTheme.textPrimary)),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),

                // Icon grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      childAspectRatio: 1),
                  itemCount: kIconCategories[_iconTab].icons.length,
                  itemBuilder: (_, i) {
                    final opt = kIconCategories[_iconTab].icons[i];
                    final sel = opt.icon.codePoint == _iconCP;
                    return GestureDetector(
                      onTap: () => setState(() => _iconCP = opt.icon.codePoint),
                      child: Container(
                        decoration: BoxDecoration(
                          color: sel ? AppTheme.textPrimary : AppTheme.cardSurface,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: sel
                                  ? AppTheme.textPrimary
                                  : AppTheme.cardBorder,
                              width: 1.0),
                        ),
                        child: Center(child: Icon(opt.icon, size: 18,
                            color: sel ? AppTheme.surface : AppTheme.textPrimary)),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Category
                _DropF(
                  label: _cat.text.isEmpty ? widget.store.text('category') : _cat.text,
                  items: _cats,
                  onSelect: (v) => setState(() => _cat.text = v),
                  isSelected: _cat.text.isNotEmpty,
                ),
                const SizedBox(height: 10),

                // Completions per day

                Text(widget.store.text('reminder'),
                    style: TextStyle(fontWeight: FontWeight.w600,
                        fontSize: 12, color: AppTheme.textSecondary)),
                const SizedBox(height: 8),
                Row(children: List.generate(7, (i) {
                  final sel = _days.contains(i);
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() =>
                      sel ? _days.remove(i) : _days.add(i)),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.transparent, // Fixed to transparent
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: sel
                                  ? AppTheme.textPrimary
                                  : AppTheme.cardBorder,
                              width: sel ? 1.5 : 1.1),
                        ),
                        child: Text(dayLabels[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textPrimary)), // Adaptive text
                      ),
                    ),
                  );
                })),

// ----------------------------------------------------
// ADDED SPACING: This separates the days from the time
                const SizedBox(height: 12),
// ----------------------------------------------------

                GestureDetector(
                  onTap: () async {
                    final t = await showTimePicker(
                        context: context, initialTime: _time);
                    if (t != null) setState(() => _time = t);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.cardBorder, width: 1.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(children: [
                      Text(widget.store.text('pickTime'),
                          style: const TextStyle(fontSize: 14)),
                      const Spacer(),
                      Text(
                        '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                            fontSize: 14, color: AppTheme.textSecondary),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 16),

// Notification toggle for this habit
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.cardBorder, width: 1.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Text(
                        widget.store.text('enableNotification'),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    _ThemedSwitch(
                      value: _notificationEnabled,
                      onChanged: (v) =>
                          setState(() => _notificationEnabled = v),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),

                Text(widget.store.text('showStreak'),
                    style: TextStyle(fontWeight: FontWeight.w600,
                        fontSize: 12, color: AppTheme.textSecondary)),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _streakType = StreakType.daily),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.transparent, // Fixed to transparent
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12)),
                          border: Border.all(
                              color: _streakType == StreakType.daily
                                  ? AppTheme.textPrimary
                                  : AppTheme.border.withOpacity(0.4),
                              width: _streakType == StreakType.daily ? 1.5 : 1.1),
                        ),
                        child: Text(widget.store.text('daily'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textPrimary)), // Adaptive text
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _streakType = StreakType.weekly),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.transparent, // Fixed to transparent
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12)),
                          border: Border.all(
                              color: _streakType == StreakType.weekly
                                  ? AppTheme.textPrimary
                                  : AppTheme.border.withOpacity(0.4),
                              width: _streakType == StreakType.weekly ? 1.5 : 1.1),
                        ),
                        child: Text(widget.store.text('weekly'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textPrimary)), // Adaptive text
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _title.text.trim().isEmpty
                          ? AppTheme.gray
                          : AppTheme.textPrimary,
                      // Adjusted foreground to fix the same white-on-white bug for the Save button
                      foregroundColor: AppTheme.surface,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                    ),
                    onPressed:
                    _title.text.trim().isEmpty ? null : _save,
                    child: Text(
                        widget.store.text(widget.existing == null ? 'save' : 'update'),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  THEMED SWITCH
// ═══════════════════════════════════════════════════════════

/// A Switch that uses black thumb/track in light mode and white thumb in dark.
class _ThemedSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ThemedSwitch({required this.value, required this.onChanged});

  @override
  State<_ThemedSwitch> createState() => _ThemedSwitchState();
}

class _ThemedSwitchState extends State<_ThemedSwitch> {
  late bool _displayValue;

  @override
  void initState() {
    super.initState();
    _displayValue = widget.value;
  }

  @override
  void didUpdateWidget(_ThemedSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.value != _displayValue) {
      _displayValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark;
    final activeTrackColor =
    isDark ? const Color(0xFF3A3A3A) : const Color(0xFF0D0D0D);
    final activeThumbColor =
    isDark ? const Color(0xFFFFFFFF) : const Color(0xFFFBF6F6);
    final inactiveTrackColor =
    isDark ? const Color(0xFF2A2A2A) : AppTheme.borderLight;
    final inactiveThumbColor =
    isDark ? const Color(0xFF888888) : AppTheme.textTertiary;

    return Semantics(
      button: true,
      toggled: _displayValue,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          final next = !_displayValue;
          setState(() => _displayValue = next);
          Future.microtask(() => widget.onChanged(next));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
          width: 46,
          height: 26,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: _displayValue ? activeTrackColor : inactiveTrackColor,
            borderRadius: BorderRadius.circular(999),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
            alignment: _displayValue ? Alignment.centerRight : Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: _displayValue ? activeThumbColor : inactiveThumbColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: _displayValue ? 0.18 : 0.08),
                    blurRadius: _displayValue ? 8 : 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  ONBOARDING FLOW
// ═══════════════════════════════════════════════════════════

class _OnboardingFlow extends StatefulWidget {
  final VoidCallback onComplete;
  const _OnboardingFlow({required this.onComplete});

  @override
  State<_OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<_OnboardingFlow> {
  final PageController _ctrl = PageController();
  int _page = 0;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _next() async {
    if (_page < 3) {
      _ctrl.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      await NotificationService.instance.requestPermissions();
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: PageView(
              controller: _ctrl,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (i) => setState(() => _page = i),
              children: [_ob1(), _ob2(), _ob3(), _ob4()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: Column(children: [
              // Page indicator dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _page == i ? 22 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _page == i ? AppTheme.textPrimary : AppTheme.textTertiary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                )),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: _next,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: AppTheme.textPrimary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      _page < 3 ? 'Continue' : 'Get Started',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.bg,
                      ),
                    ),
                  ),
                ),
              ),
              if (_page < 3)
                TextButton(
                  onPressed: widget.onComplete,
                  child: Text('Skip',
                      style: TextStyle(color: AppTheme.textTertiary, fontSize: 13)),
                )
              else
                const SizedBox(height: 36),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _ob1() => _ObPage(
    icon: Icons.track_changes_outlined,
    tag: 'Build Better Habits',
    title: 'Small steps,\nbig change.',
    body: 'Consistency beats intensity every time. Just 5–10 minutes a day, '
        'done repeatedly, rewires how you think and act. Doingnow makes '
        'showing up effortless — so you never lose your streak.',
    bullets: const [
      '✓  Track any habit — fitness, reading, journaling',
      '✓  See your progress at a glance every day',
      '✓  Build momentum that lasts for months',
    ],
    preview: _PreviewMonthCard(),
  );

  Widget _ob2() => _ObPage(
    icon: Icons.auto_graph_outlined,
    tag: 'Visualise Your Progress',
    title: 'Watch your\nstreak grow.',
    body: 'Every completed day fills a dot. Watch your monthly grid, weekly '
        'row, and yearly map fill up — turning invisible effort into '
        'something you can actually see and be proud of.',
    bullets: const [
      '✓  Month grid — see the whole month at once',
      '✓  Year view — 365 days of your journey',
      '✓  Stats — streaks, completion rate, trends',
    ],
    preview: _PreviewYearCard(),
  );

  Widget _ob3() => _ObPage(
    icon: Icons.palette_outlined,
    tag: 'Designed to Stay',
    title: 'Clean, fast,\nand private.',
    body: 'No account needed. No cloud. Your data lives only on your device. '
        'A distraction-free interface that adapts to light and dark mode — '
        'fast, reliable, and always with you.',
    bullets: const [
      '✓  100% offline — works without internet',
      '✓  No ads, no subscriptions, ever',
      '✓  Light & dark mode, multiple languages',
    ],
    preview: _PreviewCleanUI(),
  );

  Widget _ob4() => _ObPage(
    icon: Icons.notifications_outlined,
    tag: 'Stay On Track',
    title: 'Reminders\nthat show up.',
    body: 'Set a daily reminder for each habit. Doingnow sends a notification '
        'at your chosen time — even when the app is closed — so you never '
        'forget to check in.',
    bullets: const [
      '✓  Per-habit reminders at your chosen time',
      '✓  Works in the background, even when closed',
      '✓  You can always change this in Settings',
    ],
  );
}

class _ObPage extends StatelessWidget {
  final IconData icon;
  final String tag, title, body;
  final List<String>? bullets;
  final Widget? extra;
  final Widget? preview;
  const _ObPage({required this.icon, required this.tag,
    required this.title, required this.body,
    this.bullets, this.extra, this.preview});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Icon circle
        Container(
          width: 50, height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.cardSurface,
            border: Border.all(color: AppTheme.cardBorder),
          ),
          child: Center(child: Icon(icon, size: 22, color: AppTheme.textPrimary)),
        ),
        const SizedBox(height: 18),
        Text(tag.toUpperCase(),
            style: TextStyle(fontSize: 9, letterSpacing: 1.5,
                fontWeight: FontWeight.w600, color: AppTheme.textTertiary)),
        const SizedBox(height: 6),
        Text(title,
            style: TextStyle(fontSize: 26, height: 1.2,
                fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        const SizedBox(height: 14),
        Text(body,
            style: TextStyle(fontSize: 13, height: 1.65,
                color: AppTheme.textSecondary)),
        if (bullets != null) ...[
          const SizedBox(height: 16),
          ...bullets!.map((b) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(b,
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                  height: 1.4,
                )),
          )),
        ],
        if (extra != null) extra!,
        if (preview != null) ...[
          const SizedBox(height: 20),
          preview!,
        ],
        const SizedBox(height: 16),
      ]),
    );
  }
}

// ── Onboarding preview widgets ──────────────────────────

class _PreviewMonthCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Matches exact layout of _MonthCard
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 22, height: 22,
              decoration: BoxDecoration(shape: BoxShape.circle,
                  color: AppTheme.bg, border: Border.all(color: AppTheme.faintBorder)),
              child: Center(child: Icon(Icons.menu_book_outlined, size: 12,
                  color: AppTheme.textPrimary))),
          const SizedBox(width: 6),
          Expanded(child: Text('Study',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              overflow: TextOverflow.ellipsis)),
          Icon(Icons.more_horiz, color: AppTheme.textTertiary, size: 16),
        ]),
        const SizedBox(height: 4),
        Row(children: ['M','T','W','T','F','S','S'].map((d) => Expanded(
          child: Text(d, textAlign: TextAlign.center,
              style: TextStyle(fontSize: 7.5, color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500)),
        )).toList()),
        const SizedBox(height: 2),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, mainAxisSpacing: 2, crossAxisSpacing: 2,
              childAspectRatio: 1.9),
          itemCount: 35,
          itemBuilder: (_, i) {
            final done = (i * 7 + i * 3 + 11) % 10 < 6 && i < 26;
            final future = i >= 26;
            final type = future ? _CT.empty : done ? _CT.done : _CT.undone;
            return _DayCell(type: type);
          },
        ),
      ]),
    );
  }
}

class _PreviewYearCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('Year', style: TextStyle(fontWeight: FontWeight.w700,
              fontSize: 13, color: AppTheme.textPrimary)),
          const Spacer(),
          Text('31%', style: TextStyle(fontSize: 12,
              color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
        ]),
        const SizedBox(height: 10),
        // Preview dot grid: 5 rows × 18 cols
        ...List.generate(5, (row) => Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Row(
            children: List.generate(18, (col) {
              final done = row < 2 || (row == 2 && col < 5);
              final future = row >= 3;
              final type = future ? _CT.empty
                  : done ? _CT.done : _CT.undone;
              return Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.5),
                child: AspectRatio(aspectRatio: 1,
                    child: _CircleDayDot(type: type, size: 8)),
              ));
            }),
          ),
        )),
      ]),
    );
  }
}

class _PreviewCleanUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Light card
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Row(children: [
          Container(width: 32, height: 32,
              decoration: BoxDecoration(shape: BoxShape.circle,
                  color: AppTheme.bg, border: Border.all(color: AppTheme.faintBorder)),
              child: Center(child: Icon(Icons.fitness_center_outlined,
                  size: 14, color: AppTheme.textPrimary))),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Morning run', style: TextStyle(fontWeight: FontWeight.w600,
                    fontSize: 13, color: AppTheme.textPrimary)),
                Text('Health', style: TextStyle(fontSize: 10,
                    color: AppTheme.textSecondary)),
              ])),
          Container(width: 22, height: 22,
            decoration: BoxDecoration(shape: BoxShape.circle,
                color: AppTheme.doneDot),
          ),
        ]),
      ),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Row(children: [
          Container(width: 32, height: 32,
              decoration: BoxDecoration(shape: BoxShape.circle,
                  color: AppTheme.bg, border: Border.all(color: AppTheme.faintBorder)),
              child: Center(child: Icon(Icons.menu_book_outlined,
                  size: 14, color: AppTheme.textPrimary))),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Read 20 pages', style: TextStyle(fontWeight: FontWeight.w600,
                    fontSize: 13, color: AppTheme.textPrimary)),
                Text('Learning', style: TextStyle(fontSize: 10,
                    color: AppTheme.textSecondary)),
              ])),
          Container(width: 22, height: 22,
            decoration: BoxDecoration(shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(color: AppTheme.cardBorder)),
          ),
        ]),
      ),
    ]);
  }
}

class _ObStep extends StatelessWidget {
  final String num, text;
  const _ObStep(this.num, this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Container(
        width: 20, height: 20,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: AppTheme.textPrimary),
        child: Center(child: Text(num,
            style: const TextStyle(fontSize: 10, color: Colors.white,
                fontWeight: FontWeight.w700))),
      ),
      const SizedBox(width: 10),
      Expanded(child: Text(text,
          style: TextStyle(fontSize: 13, color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500))),
    ]),
  );
}

// ═══════════════════════════════════════════════════════════
//  NOTIFICATION PERMISSION SCREEN
// ═══════════════════════════════════════════════════════════

class _NotificationPermissionScreen extends StatelessWidget {
  final VoidCallback onAllow;
  final VoidCallback onDeny;
  const _NotificationPermissionScreen(
      {required this.onAllow, required this.onDeny});

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark;
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.cardSurface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.cardBorder, width: 1),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  size: 36,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 28),
              // Title
              Text(
                'Stay on track',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              // Description
              Text(
                'Enable notifications to get reminders for your habits.',
                style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.faintBorder),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('For reliable reminders:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary)),
                  const SizedBox(height: 6),
                  _PermStep('1', 'Go to App Info → Battery'),
                  _PermStep('2', 'Select "Unrestricted" or "No restriction"'),
                  _PermStep('3', 'This lets notifications work even when app is closed'),
                ]),
              ),
              const Spacer(),
              // Allow button
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: onAllow,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.textPrimary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'Allow',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.bg,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Don't allow button
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: onDeny,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border:
                      Border.all(color: AppTheme.cardBorder, width: 1),
                    ),
                    child: Text(
                      'Don\'t Allow',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermStep extends StatelessWidget {
  final String number;
  final String text;
  const _PermStep(this.number, this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 16, height: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.textPrimary,
        ),
        child: Center(child: Text(number,
            style: const TextStyle(fontSize: 9, color: Colors.white,
                fontWeight: FontWeight.w700))),
      ),
      const SizedBox(width: 8),
      Expanded(child: Text(text,
          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary))),
    ]),
  );
}

class _FF extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  const _FF({required this.controller, required this.hint, this.maxLines = 1});

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    maxLines: maxLines,
    autocorrect: false,
    enableSuggestions: false,
    style: TextStyle(color: AppTheme.textPrimary, fontSize: 14),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppTheme.textTertiary, fontSize: 14),
      filled: true,
      fillColor: Colors.transparent,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.cardBorder, width: 1.0)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.cardBorder, width: 1.0)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.textPrimary, width: 1.4)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    ),
  );
}

class _DropF extends StatelessWidget {
  final String label;
  final List<String> items;
  final ValueChanged<String> onSelect;
  final bool isSelected;
  const _DropF(
      {required this.label, required this.items, required this.onSelect,
        this.isSelected = false});

  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
    onSelected: onSelect,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    color: AppTheme.surface,
    elevation: 4,
    itemBuilder: (_) => items
        .map((i) => PopupMenuItem(
      value: i,
      child: Text(i, style: TextStyle(
          color: AppTheme.textPrimary, fontSize: 14)),
    ))
        .toList(),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(
            color: isSelected ? AppTheme.textPrimary : AppTheme.cardBorder,
            width: isSelected ? 1.5 : 1.0),
        borderRadius: BorderRadius.circular(12),
        color: AppTheme.surface,
      ),
      child: Row(children: [
        Expanded(child: Text(label,
            style: TextStyle(fontSize: 14,
                color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400))),
        Icon(Icons.keyboard_arrow_down,
            color: AppTheme.textSecondary, size: 18),
      ]),
    ),
  );
}

class _SBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.cardBorder, width: 1.0),
        shape: BoxShape.circle,
        color: AppTheme.surface,
      ),
      child: Icon(icon, size: 18, color: AppTheme.textPrimary),
    ),
  );
}

// ═══════════════════════════════════════════════════════════
//  HELPERS
// ═══════════════════════════════════════════════════════════

String _monthAbbr(int month) {
  const names = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  return names[month - 1];
}

bool _isSameDate(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

bool _isFutureDate(DateTime date) {
  final now = DateTime.now();
  final d = DateTime(date.year, date.month, date.day);
  final t = DateTime(now.year, now.month, now.day);
  return d.isAfter(t);
}

bool _isPastDate(DateTime date) {
  final now = DateTime.now();
  final d = DateTime(date.year, date.month, date.day);
  final t = DateTime(now.year, now.month, now.day);
  return d.isBefore(t);
}

List<String> _weekdayLabels(BuildContext context) =>
    AppStrings.weekdays(_globalStore.languageCode);

String _formatMonthYear(BuildContext context, DateTime date) =>
    '${AppStrings.months(_globalStore.languageCode)[date.month - 1]} ${date.year}';

String _formatFullDate(BuildContext context, DateTime date) =>
    '${date.day} ${AppStrings.months(_globalStore.languageCode)[date.month - 1]} ${date.year}';

String _monthName(int m) =>
    AppStrings.months(_globalStore.languageCode)[m - 1];

void _handleHabitDayTap(
    BuildContext context,
    HabitStore store,
    Habit habit,
    DateTime date,
    ) {
  // Only today is tappable — past days are locked, future days are locked
  if (!_isSameDate(date, DateTime.now())) return;
  if (!habit.isScheduledOn(date)) return;
  store.toggleComplete(habit, date);
}

Future<void> _showShareSheet(
    BuildContext context,
    HabitStore store,
    Habit habit,
    ) async {
  final today = DateTime.now();
  final summary = [
    habit.title,
    '${store.text('completedDays')}: ${habit.completedDaysInYear(today.year)}',
    '${store.text('completionRate')}: ${(habit.completionRateInYear(today.year) * 100).round()}%',
    habit.isScheduledOn(today)
        ? '${store.text('scheduledToday')} - ${habit.isCompletedOn(today) ? store.text('todayComplete') : store.text('notCompleted')}'
        : store.text('notScheduledToday'),
  ].join('\n');

  showModalBottomSheet(
    context: context,
    backgroundColor: AppTheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dragHandle(),
            Text(store.text('shareSummary'),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 14),
            _Card(
              child: Row(
                children: [
                  _HabitIconBox(iconData: habit.iconData, size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(habit.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(summary,
                            style: TextStyle(
                                color: AppTheme.textSecondary, height: 1.5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textPrimary,
                      side: BorderSide(color: AppTheme.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.pop(sheetContext),
                    child: Text(store.text('close')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.textPrimary,
                      foregroundColor: AppTheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: summary));
                      if (sheetContext.mounted) Navigator.pop(sheetContext);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(store.text('copied'))),
                        );
                      }
                    },
                    child: Text(store.text('copyText')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _confirmDeleteHabit(
    BuildContext context,
    HabitStore store,
    Habit habit,
    ) async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(store.text('delete'),
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(
              '"${habit.title}" ${store.text('deleteProgressTitle')}',
              style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                  height: 1.4),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(dialogContext, false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: AppTheme.cardSurface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.cardBorder),
                    ),
                    child: Text(store.text('cancel'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(dialogContext, true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: AppTheme.danger,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(store.text('delete'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    ),
  );
  if (shouldDelete == true) {
    store.deleteHabit(habit.id);
  }
}