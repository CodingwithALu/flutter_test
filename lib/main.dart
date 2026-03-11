import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test/app.dart';
import 'firebase_options.dart';
Future<void> main() async {
  // Ensure that widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize GetX Local Storage
  // await GetStorage.init();
  // Remove # sign from url
  // setPathUrlStrategy();
  // Initialize Firebase & Authentication Repository
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);
  //Main App Start here...
  runApp(const App());
}
