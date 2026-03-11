import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/navigation_menu.dart';
import 'package:test/route/app_route.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const NavigationMenu(),
      getPages: AppRoutes.pages,
      locale: const Locale('vi'),
    );
  }
}
