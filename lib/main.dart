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
        brightness: Brightness.light, // Aydınlık tema
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: AppRoutes.routes,
    );
  }
}
