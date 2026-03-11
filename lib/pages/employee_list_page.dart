import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/employee.dart';
import '../data/employee_repository.dart';
import 'employee_form_page.dart';

class EmployeeListPage extends StatelessWidget {
  const EmployeeListPage({super.key, required this.repository});

  final EmployeeRepository repository;

  Future<void> _confirmDelete(BuildContext context, Employee e) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xóa nhân sự?'),
          content: Text('Bạn có chắc muốn xóa "${e.fullName}" (${e.code})?'),
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
      await repository.deleteEmployee(e.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã xóa')));
    } catch (err) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Xóa thất bại: $err')));
    }
  }

  Future<void> _openForm(BuildContext context, {Employee? employee}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            EmployeeFormPage(repository: repository, employee: employee),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách nhân sự')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context),
        tooltip: 'Thêm',
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Employee>>(
        stream: repository.watchEmployees(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;
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
                title: Text('${e.fullName} (${e.code})'),
                subtitle: Text(subtitleParts.join(' • ')),
                onTap: () => _openForm(context, employee: e),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    IconButton(
                      tooltip: 'Sửa',
                      icon: const Icon(Icons.edit),
                      onPressed: () => _openForm(context, employee: e),
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
        },
      ),
    );
  }
}
