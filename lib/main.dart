import 'package:dersai_app/core/routes/app_routes.dart';
import 'package:dersai_app/models/note_model.dart';
import 'package:dersai_app/provider/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'core/constants/size_config.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'provider/note_provider.dart';
import 'package:dersai_app/services/notification_service.dart';
import 'views/reminders_page.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("Firebase baslatildi");
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(NoteModelAdapter());
  await Hive.openBox<NoteModel>('notes');
  final noteProvider = NoteProvider();
  await noteProvider.loadNotes();
  await NotificationService.init(); // Bildirim servisini başlat

  // ANDROID 12+ EXPLICIT ALARM İZNİ
  if (Platform.isAndroid) {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt >= 31) {
      final plugin = FlutterLocalNotificationsPlugin();
      final androidImplementation =
          plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      // requestPermission yerine requestExactAlarmsPermission kullan
      await androidImplementation?.requestExactAlarmsPermission();
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => noteProvider),
        ChangeNotifierProvider(create: (_) => MyImageProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MaterialApp(
      title: 'DersAI',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        ...AppRoutes.routes,
        '/reminders': (context) => const RemindersPage(),
      },
    );
  }
}
