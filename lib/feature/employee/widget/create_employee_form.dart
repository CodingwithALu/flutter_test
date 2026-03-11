import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test/controller/employee_controller.dart';
import 'package:test/utils/validators/validation.dart';

class CreateEmployeeFormPage extends StatelessWidget {
  const CreateEmployeeFormPage({super.key});

  Future<void> _pickDob(
    BuildContext context,
    EmployeeController controller,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.dob.value,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    controller.dob.value = picked;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmployeeController());
    final df = DateFormat('dd/MM/yyyy');
    return Scaffold(
      appBar: AppBar(title: Text('Thêm nhân sự')),
      body: SafeArea(
        child: Form(
          key: controller.employeeKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: controller.fullNameController,
                decoration: const InputDecoration(labelText: 'Họ tên'),
                validator: (v) =>
                    TValidator.validateEmptyText('Vui lòng nhập họ tên', v),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => TValidator.validateEmail(v),
              ),
              const SizedBox(height: 12),
              Obx(
                () => InkWell(
                  onTap: () => _pickDob(context, controller),
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Ngày sinh'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(df.format(controller.dob.value)),
                        const Icon(Icons.calendar_month),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.phoneController,
                decoration: const InputDecoration(labelText: 'Điện thoại'),
                validator: (v) => TValidator.validatePhoneNumber(v),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller.addressController,
                decoration: const InputDecoration(labelText: 'Địa chỉ'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async => controller.createEmployee(),
                child: Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
