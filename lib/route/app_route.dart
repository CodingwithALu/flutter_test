import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:test/feature/home_screen.dart';
import 'package:test/route/route.dart';

import '../feature/employee_screen.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: TRoutes.home, page: () => const HomeScreen()),
    GetPage(name: TRoutes.employee, page: () => const EmployeeScreen()),
  ];
}
