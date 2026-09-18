import 'dart:async';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pastafara/src/router/app_router.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    providerAndroid: kDebugMode
        ? const AndroidDebugProvider()
        : const AndroidPlayIntegrityProvider(),
  );

  runApp(const MainApp());
  unawaited(_testFirebaseAi());
}

Future<void> _testFirebaseAi() async {
  final model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-3.5-flash',
  );
  final prompt = [Content.text('Say Hello')];

  try {
    final response = await model.generateContent(prompt);
    debugPrint(response.text);
  } catch (error, stackTrace) {
    debugPrint('Firebase AI request failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: appRouter);
  }
}
