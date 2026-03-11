import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:test/controller/employee_controller.dart';
import 'package:test/feature/employee/widget/create_employee_form.dart';
import 'package:test/route/route.dart';
import '../controller/employee_page_controller.dart';
import '../models/employee_model.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = EmployeePageController.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách nhân sự')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const CreateEmployeeFormPage()),
        tooltip: 'Thêm',
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        final items = controller.allEmployees;
        if (items.isEmpty) {
          return const Center(child: Text('Chưa có dữ liệu'));
        }
        final df = DateFormat('dd/MM/yyyy');
        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final e = items[index];
            final subtitleParts = <String>[];
            if (e.email.trim().isNotEmpty) subtitleParts.add(e.email.trim());
            if (e.phone.trim().isNotEmpty) subtitleParts.add(e.phone.trim());
            if (e.address.trim().isNotEmpty) subtitleParts.add(e.address.trim());
            subtitleParts.add(df.format(e.dateOfBirth));
            return ListTile(
              title: Text(e.fullName),
              subtitle: Text(subtitleParts.join(' • ')),
              onTap: () => Get.toNamed(TRoutes.editEmployee, arguments: e),
              trailing: Wrap(
                spacing: 8,
                children: [
                  IconButton(
                    tooltip: 'Sửa',
                    icon: const Icon(Icons.edit),
                    onPressed: () =>
                        Get.toNamed(TRoutes.editEmployee, arguments: e),
                  ),
                  IconButton(
                    tooltip: 'Xóa',
                    icon: const Icon(Icons.delete),
                    onPressed: () => _confirmDelete(context, e),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  // delete
  Future<void> _confirmDelete(BuildContext context, Employee e) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xóa nhân sự!'),
          content: Text('Bạn có chắc muốn xóa'),
          actions: [
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Hủy'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Xóa'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
    if (ok != true) return;
    final controller = Get.put(EmployeeController());
    await controller.deleteEmployee(e.id.toString());
  }
}
