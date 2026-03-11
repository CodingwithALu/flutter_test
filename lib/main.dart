import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'data/employee_repository.dart';
import 'data/firestore_employee_repository.dart';
import 'firebase_options.dart';
import 'pages/employee_list_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.repository, this.initializeFirebase = true});

  final EmployeeRepository? repository;
  final bool initializeFirebase;

  @override
  Widget build(BuildContext context) {
    final repo = repository ?? FirestoreEmployeeRepository();

    Widget app = MaterialApp(
      title: 'Nhân sự',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: EmployeeListPage(repository: repo),
    );

    if (!initializeFirebase) return app;

    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            title: 'Nhân sự',
            home: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Firebase init lỗi: ${snapshot.error}\n\n'
                    'Hãy chạy flutterfire configure và cấu hình Firebase.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            title: 'Nhân sự',
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return app;
      },
    );
  }
}
