import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'login_screen.dart';
import 'register_screen.dart';
import 'pages/home_page.dart';
import 'pages/araclar_page.dart';
import 'pages/musteriler_page.dart';
import 'pages/sozlesmeler_page.dart';
import 'pages/raporlar_page.dart';

import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Araç Kiralama Paneli',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
      ),
      // Kullanıcı giriş yapmış mı kontrol ediyoruz
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const HomePage(); // Kullanıcı varsa home ekranı
          } else {
            return const LoginScreen(); // Yoksa giriş ekranı
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomePage(),
        '/araclar': (context) => const AraclarPage(),
        '/musteriler': (context) => const MusterilerPage(),
        '/sozlesmeler': (context) => const SozlesmelerPage(),
        '/raporlar': (context) => const RaporlarPage(),
      },
    );
  }
}
