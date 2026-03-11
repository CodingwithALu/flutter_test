import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/models/employee_model.dart';
import 'package:test/utils/constants/image_strings.dart';
import 'package:test/utils/helpers/network_manager.dart';
import 'package:test/utils/popups/full_screen_loader.dart';
import 'package:test/utils/popups/loaders.dart';
import 'employee_page_controller.dart';
import '../repository/employee_repository.dart';

class EditEmployeeController extends GetxController {
  static EditEmployeeController get instance => Get.find();
  final repository = EmployeeRepository.instance;
  GlobalKey<FormState> employeeKey = GlobalKey<FormState>();
  RxList<Employee> allEmployees = <Employee>[].obs;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final dob = DateTime.now().obs;

  Future<void> initEmployee(Employee employee) async {
    try {
      fullNameController.text = employee.fullName;
      emailController.text = employee.email;
      dob.value = employee.dateOfBirth;
      phoneController.text = employee.phone;
      addressController.text = employee.address;
      update();
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> updateEmployee(Employee employee) async {
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
      final updatedEmployee = Employee(
        id: employee.id,
        fullName: fullNameController.text.trim(),
        dateOfBirth: dob.value,
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
      );
      await repository.updateEmployee(updatedEmployee);
      final pageController = EmployeePageController.instance;
      final index = pageController.allEmployees.indexWhere(
        (e) => e.id != null && e.id == updatedEmployee.id,
      );
      if (index != -1) {
        pageController.allEmployees[index] = updatedEmployee;
      }
      Get.back();
      TLoaders.successSnackBar(
        title: 'Done',
        message: 'Employee updated successfully.',
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'On Snap!', message: e.toString());
    } finally {
      TFullScreenLoader.stopLoading();
    }
  }
}
