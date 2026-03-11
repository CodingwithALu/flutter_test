import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/models/employee_model.dart';
import 'package:test/utils/constants/image_strings.dart';
import 'package:test/utils/helpers/network_manager.dart';
import 'package:test/utils/popups/full_screen_loader.dart';
import 'package:test/utils/popups/loaders.dart';
import '../repository/employee_repository.dart';

class EmployeePageController extends GetxController {
  static EmployeePageController get instance => Get.find();
  final repository = Get.put(EmployeeRepository());
  GlobalKey<FormState> employeeKey = GlobalKey<FormState>();
  final RxList<Employee> allEmployees = <Employee>[].obs;
  @override
  void onReady() {
    super.onReady();
    fetchEmployeeWidthPage(1, 10);
  }

  Future<void> fetchEmployeeWidthPage(int page, int pageSize) async {
    try {
      TFullScreenLoader.openLoadingDialog(
        'We are processing your information...',
        TImages.docerAnimation,
      );
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      final result = await repository.fetchEmployeeWidthPages(page, pageSize);
      allEmployees.assignAll(result);
      TLoaders.successSnackBar(
        title: 'Done',
        message: 'Employees loaded successfully.',
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'On Snap!', message: e.toString());
    } finally {
      TFullScreenLoader.stopLoading();
    }
  }
}
