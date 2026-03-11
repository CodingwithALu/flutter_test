// ignore: unused_import
import 'package:test/controller/employee_page_controller.dart';
import 'package:test/utils/helpers/network_manager.dart';
import 'package:get/get.dart';

class GeneralBindings extends Bindings {
  @override
  // ignore: void_checks
  void dependencies() {
    /// Core
    Get.lazyPut(() => NetworkManager(), fenix: true);
    Get.lazyPut(() => EmployeePageController(), fenix: true);
  }
}
