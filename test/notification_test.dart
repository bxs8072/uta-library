import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/timezone.dart' as tz;

String convertDateToISO8601String(tz.TZDateTime dateTime) {
  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    }
    return '0$n';
  }

  String _fourDigits(int n) {
    final int absN = n.abs();
    final String sign = n < 0 ? '-' : '';
    if (absN >= 1000) {
      return '$n';
    }
    if (absN >= 100) {
      return '${sign}0$absN';
    }
    if (absN >= 10) {
      return '${sign}00$absN';
    }
    return '${sign}000$absN';
  }

  return '${_fourDigits(dateTime.year)}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)}T${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}'; // ignore: lines_longer_than_80_chars
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  group('Android', () {
    const MethodChannel channel =
        MethodChannel('dexterous.com/flutter/local_notifications');
    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      // ignore: always_specify_types
      channel.setMockMethodCallHandler((methodCall) async {
        log.add(methodCall);
        if (methodCall.method == 'pendingNotificationRequests') {
          return <Map<String, Object?>>[];
        } else if (methodCall.method == 'getNotificationAppLaunchDetails') {
          return null;
        } else if (methodCall.method == 'getActiveNotifications') {
          return <Map<String, Object?>>[];
        }
      });
    });

    tearDown(() {
      log.clear();
    });

    test('initialize', () async {
      const AndroidInitializationSettings androidInitializationSettings =
          AndroidInitializationSettings('app_icon');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: androidInitializationSettings);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
      expect(log, <Matcher>[
        isMethodCall('initialize', arguments: <String, Object>{
          'defaultIcon': 'app_icon',
        })
      ]);
    });

    test('show without Android-specific details', () async {
      const AndroidInitializationSettings androidInitializationSettings =
          AndroidInitializationSettings('app_icon');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: androidInitializationSettings);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
      await flutterLocalNotificationsPlugin.show(
          1, 'notification title', 'notification body', null);
      expect(
          log.last,
          isMethodCall('show', arguments: <String, Object?>{
            'id': 1,
            'title': 'notification title',
            'body': 'notification body',
            'payload': '',
            'platformSpecifics': null,
          }));
    });
    group('createNotificationChannelGroup', () {
      test('without description', () async {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()!
            .createNotificationChannelGroup(
                const AndroidNotificationChannelGroup('groupId', 'groupName'));
        expect(log, <Matcher>[
          isMethodCall('createNotificationChannelGroup',
              arguments: <String, Object?>{
                'id': 'groupId',
                'name': 'groupName',
                'description': null,
              })
        ]);
      });
      test('with description', () async {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()!
            .createNotificationChannelGroup(
                const AndroidNotificationChannelGroup('groupId', 'groupName',
                    description: 'groupDescription'));
        expect(log, <Matcher>[
          isMethodCall('createNotificationChannelGroup',
              arguments: <String, Object>{
                'id': 'groupId',
                'name': 'groupName',
                'description': 'groupDescription',
              })
        ]);
      });
    });

    test('createNotificationChannel with default settings', () async {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .createNotificationChannel(const AndroidNotificationChannel(
              'channelId', 'channelName',
              description: 'channelDescription'));
      expect(log, <Matcher>[
        isMethodCall('createNotificationChannel', arguments: <String, Object?>{
          'id': 'channelId',
          'name': 'channelName',
          'description': 'channelDescription',
          'groupId': null,
          'showBadge': true,
          'importance': Importance.defaultImportance.value,
          'playSound': true,
          'enableVibration': true,
          'vibrationPattern': null,
          'enableLights': false,
          'ledColorAlpha': null,
          'ledColorRed': null,
          'ledColorGreen': null,
          'ledColorBlue': null,
          'channelAction':
              AndroidNotificationChannelAction.createIfNotExists.index,
        })
      ]);
    });

    test('createNotificationChannel with non-default settings', () async {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .createNotificationChannel(const AndroidNotificationChannel(
            'channelId',
            'channelName',
            description: 'channelDescription',
            groupId: 'channelGroupId',
            showBadge: false,
            importance: Importance.max,
            playSound: false,
            enableLights: true,
            enableVibration: false,
            ledColor: Color.fromARGB(255, 255, 0, 0),
          ));
      expect(log, <Matcher>[
        isMethodCall('createNotificationChannel', arguments: <String, Object?>{
          'id': 'channelId',
          'name': 'channelName',
          'description': 'channelDescription',
          'groupId': 'channelGroupId',
          'showBadge': false,
          'importance': Importance.max.value,
          'playSound': false,
          'enableVibration': false,
          'vibrationPattern': null,
          'enableLights': true,
          'ledColorAlpha': 255,
          'ledColorRed': 255,
          'ledColorGreen': 0,
          'ledColorBlue': 0,
          'channelAction':
              AndroidNotificationChannelAction.createIfNotExists.index,
        })
      ]);
    });

    test('deleteNotificationChannel', () async {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .deleteNotificationChannel('channelId');
      expect(log, <Matcher>[
        isMethodCall('deleteNotificationChannel', arguments: 'channelId')
      ]);
    });

    test('getActiveNotifications', () async {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .getActiveNotifications();
      expect(log,
          <Matcher>[isMethodCall('getActiveNotifications', arguments: null)]);
    });

    test('cancel', () async {
      await flutterLocalNotificationsPlugin.cancel(1);
      expect(log, <Matcher>[
        isMethodCall('cancel', arguments: <String, Object?>{
          'id': 1,
          'tag': null,
        })
      ]);
    });

    test('cancel with tag', () async {
      await flutterLocalNotificationsPlugin.cancel(1, tag: 'tag');
      expect(log, <Matcher>[
        isMethodCall('cancel', arguments: <String, Object>{
          'id': 1,
          'tag': 'tag',
        })
      ]);
    });

    test('cancelAll', () async {
      await flutterLocalNotificationsPlugin.cancelAll();
      expect(log, <Matcher>[isMethodCall('cancelAll', arguments: null)]);
    });

    test('pendingNotificationRequests', () async {
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      expect(log, <Matcher>[
        isMethodCall('pendingNotificationRequests', arguments: null)
      ]);
    });

    test('getActiveNotifications', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .getActiveNotifications();
      expect(log,
          <Matcher>[isMethodCall('getActiveNotifications', arguments: null)]);
    });

    test('getNotificationAppLaunchDetails', () async {
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
      expect(log, <Matcher>[
        isMethodCall('getNotificationAppLaunchDetails', arguments: null)
      ]);
    });

    test('startForegroundService', () async {
      const AndroidInitializationSettings androidInitializationSettings =
          AndroidInitializationSettings('app_icon');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: androidInitializationSettings);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .startForegroundService(1, 'notification title', 'notification body');
      expect(
          log.last,
          isMethodCall('startForegroundService', arguments: <String, Object?>{
            'notificationData': <String, Object?>{
              'id': 1,
              'title': 'notification title',
              'body': 'notification body',
              'payload': '',
              'platformSpecifics': null,
            },
            'startType': AndroidServiceStartType.startSticky.value,
            'foregroundServiceTypes': null
          }));
    });

    test('stopForegroundService', () async {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .stopForegroundService();
      expect(
          log.last,
          isMethodCall(
            'stopForegroundService',
            arguments: null,
          ));
    });

    test('areNotificationsEnabled', () async {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .areNotificationsEnabled();
      expect(
          log.last, isMethodCall('areNotificationsEnabled', arguments: null));
    });
  });
}
