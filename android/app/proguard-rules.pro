# flutter_local_notifications — CRITICAL
# Without these, R8 strips ScheduledNotificationReceiver in release builds.
# AlarmManager fires but finds no class → notification never shows.
# This is the #1 cause of "show() works, zonedSchedule() never fires".
-keep class com.dexterous.** { *; }
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keepnames class com.dexterous.** { *; }
-keepclassmembers class com.dexterous.** { *; }

# Keep all BroadcastReceivers (AlarmManager needs them alive)
-keep public class * extends android.content.BroadcastReceiver { *; }

# Gson — used internally by flutter_local_notifications to persist alarms
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn com.google.gson.**

# Flutter engine
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**