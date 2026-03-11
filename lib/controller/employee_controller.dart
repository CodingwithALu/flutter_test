import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test/models/employee_model.dart';
import 'package:test/utils/constants/image_strings.dart';
import 'package:test/utils/helpers/network_manager.dart';
import 'package:test/utils/popups/full_screen_loader.dart';
import 'package:test/utils/popups/loaders.dart';
import '../repository/employee_repository.dart';

class EmployeeController extends GetxController {
  static EmployeeController get instance => Get.find();
  final repository = EmployeeRepository.instance;
  GlobalKey<FormState> employeeKey = GlobalKey<FormState>();
  RxList<Employee> allEmployees = <Employee>[].obs;
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final dob = DateTime.now().obs;
  Future<void> searchEmployees(String text, {int limit = 20}) async {
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
      final result = await repository.searchEmployees(text, limit: limit);
      allEmployees.assignAll(result);
      TLoaders.successSnackBar(title: 'Done', message: 'Search completed.');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'On Snap!', message: e.toString());
    } finally {
      TFullScreenLoader.stopLoading();
    }
  }

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
      await repository.createEmployee(item, isNew);
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
      await repository.updateEmployee(employee);
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

  /// Delete employee by document id.
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
