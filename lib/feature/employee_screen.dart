import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:test/feature/employee/widget/create_employee_form.dart';
import 'package:test/feature/employee/widget/edit_employee_from.dart';
import 'package:test/repository/employee_repository.dart';

import '../controller/employee_page_controller.dart';
import '../models/employee_model.dart';
import '../utils/popups/loaders.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  Future<void> _confirmDelete(BuildContext context, Employee e) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xóa nhân sự?'),
          content: Text('Bạn có chắc muốn xóa "${e.fullName}"'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (ok != true) return;
    try {
      // await controller.deleteEmployee(e.id);
      if (!context.mounted) return;
      TLoaders.successSnackBar(title: 'Thành công', message: 'Đã xóa');
    } catch (err) {
      if (!context.mounted) return;
      TLoaders.errorSnackBar(title: 'Lỗi', message: 'Xóa thất bại: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmployeePageController());
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
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final e = items[index];
            final subtitleParts = <String>[];
            if (e.email.trim().isNotEmpty) subtitleParts.add(e.email.trim());
            if (e.phone.trim().isNotEmpty) subtitleParts.add(e.phone.trim());
            subtitleParts.add('DOB: ${df.format(e.dateOfBirth)}');
            return ListTile(
              title: Text(e.fullName),
              subtitle: Text(subtitleParts.join(' • ')),
              onTap: () => Get.to(() => const EditEmployeeFrom()),
              trailing: Wrap(
                spacing: 8,
                children: [
                  IconButton(
                    tooltip: 'Sửa',
                    icon: const Icon(Icons.edit),
                    onPressed: () => Get.to(() => const EditEmployeeFrom()),
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
}
