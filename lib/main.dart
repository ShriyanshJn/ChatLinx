// Streams - Continuous flow of asynchronous data
// We have a pipe (stream controller) in which data input (sink) and data output (stream)
// Types - 1. Single subscription -> Only one subscriber(widget) can listen to a particular stream
//         2. Multi subscription -> Multiple widget can listen to a stream
// To make a particular widget listen to the stream controller we wrap it with stream builder

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'package:chat_app/screens/auth.dart';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 32, 174, 199),
        ),
      ),
      home: StreamBuilder(
          // stream: _streamController.stream (pipe.stream)
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // time when firebase is checking the stream
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            // if pipe has user data (auth token's there)
            if (snapshot.hasData) {
              return const ChatScreen();
            }
            return const AuthScreen();
          }),
    );
  }
}
