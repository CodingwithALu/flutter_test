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

  final RxInt _page = 1.obs;
  final RxInt _pageSize = 10.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  @override
  void onReady() {
    super.onReady();
    fetchEmployeeWidthPage(1, 10);
  }

  Future<void> fetchEmployeeWidthPage(int page, int pageSize) async {
    try {
      _page.value = page;
      _pageSize.value = pageSize;
      hasMore.value = true;

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
      hasMore.value = result.length >= pageSize;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'On Snap!', message: e.toString());
    } finally {
      TFullScreenLoader.stopLoading();
    }
  }

  Future<void> loadNextPage() async {
    if (isLoadingMore.value) return;
    if (!hasMore.value) return;
    if (allEmployees.isEmpty) return;

    isLoadingMore.value = true;
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      final nextPage = _page.value + 1;
      final result = await repository.fetchEmployeeWidthPages(
        nextPage,
        _pageSize.value,
      );

      if (result.isEmpty) {
        hasMore.value = false;
        return;
      }

      allEmployees.addAll(result);
      _page.value = nextPage;
      if (result.length < _pageSize.value) hasMore.value = false;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'On Snap!', message: e.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }
}
