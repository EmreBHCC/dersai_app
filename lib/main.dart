import 'package:dersai_app/components/image_provider.dart';
import 'package:dersai_app/home.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'direct_tanima.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'components/note_provider.dart';
import 'user_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Firebase baslatildi");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
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
    return MaterialApp(
      title: 'DersAI',
      theme: ThemeData(
        brightness: Brightness.light, // Aydınlık tema
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(), // Ana sayfanın geleceği yer
        '/direct_tanima': (context) => DirectTanimaPage(),
        '/user': (context) => const UserPage(),
      },
    );
  }
}


