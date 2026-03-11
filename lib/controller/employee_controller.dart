import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/models/employee_model.dart';
import 'package:test/utils/constants/image_strings.dart';
import 'package:test/utils/helpers/network_manager.dart';
import 'package:test/utils/popups/full_screen_loader.dart';
import 'package:test/utils/popups/loaders.dart';
import 'employee_page_controller.dart';
import '../repository/employee_repository.dart';

class EmployeeController extends GetxController {
  static EmployeeController get instance => Get.find();
  final repository = EmployeeRepository.instance;
  final controller = EmployeePageController.instance;
  GlobalKey<FormState> employeeKey = GlobalKey<FormState>();
  RxList<Employee> allEmployees = <Employee>[].obs;
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final dob = DateTime.now().obs;

  Future<void> createEmployee({bool isNew = true}) async {
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
      final formState = employeeKey.currentState;
      if (formState != null && !formState.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      final item = Employee(
        fullName: fullNameController.text.trim(),
        dateOfBirth: dob.value,
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
      );
      final createdId = await repository.createEmployee(item, isNew);
      final createdEmployee = Employee(
        id: createdId,
        fullName: item.fullName,
        dateOfBirth: item.dateOfBirth,
        email: item.email,
        phone: item.phone,
        address: item.address,
      );
      controller.allEmployees.insert(0, createdEmployee);
      Get.back();
      TLoaders.successSnackBar(
        title: 'Done',
        message: 'Employee created successfully.',
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'On Snap!', message: e.toString());
    } finally {
      TFullScreenLoader.stopLoading();
    }
  }

  Future<void> deleteEmployee(String id) async {
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
      await repository.deleteEmployee(id);
      controller.allEmployees.removeWhere((e) => e.id == id);
      allEmployees.removeWhere((e) => e.id == id);
      TLoaders.successSnackBar(
        title: 'Done',
        message: 'Employee deleted successfully.',
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'On Snap!', message: e.toString());
    } finally {
      TFullScreenLoader.stopLoading();
    }
  }
}
