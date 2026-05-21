import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize the full IANA timezone database
  tz.initializeTimeZones();

  // 2. Set tz.local to the device's actual timezone
  await _initLocalTimezone();

  // 3. Initialize notification plugin + channel (creates channel, requests perms)
  await NotificationService.instance.init();

  runApp(const HabitApp());
}

Future<void> _initLocalTimezone() async {
  // flutter_timezone plugin is Android/iOS only — guard before calling
  if (Platform.isAndroid || Platform.isIOS) {
    try {
      // Call flutter_timezone via its MethodChannel directly
      // This avoids import-level linker errors on Windows/macOS/Linux
      const channel = MethodChannel('flutter_timezone');
      final tzName = await channel.invokeMethod<String>('getLocalTimezone');
      if (tzName != null && tzName.isNotEmpty) {
        tz.setLocalLocation(tz.getLocation(tzName));
        debugPrint('[main] timezone: $tzName (flutter_timezone)');
        return;
      }
    } catch (e) {
      debugPrint('[main] flutter_timezone unavailable: $e');
    }
  }

  // Fallback for all platforms (Windows dev, iOS simulator, timezone plugin failure):
  // Derive timezone from UTC offset using Etc/GMT naming.
  // IMPORTANT: Etc/GMT sign convention is INVERTED vs UTC offset:
  //   UTC+5:30 → inHours=5  → sign='-' → 'Etc/GMT-5'  ✓
  //   UTC-5:00 → inHours=-5 → sign='+' → 'Etc/GMT+5'  ✓
  try {
    final h = DateTime.now().timeZoneOffset.inHours;
    final sign = h >= 0 ? '-' : '+';
    tz.setLocalLocation(tz.getLocation('Etc/GMT$sign${h.abs()}'));
    debugPrint('[main] timezone: Etc/GMT$sign${h.abs()} (offset fallback)');
  } catch (e) {
    tz.setLocalLocation(tz.UTC);
    debugPrint('[main] timezone: UTC (last resort)');
  }
}