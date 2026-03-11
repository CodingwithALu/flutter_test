import 'dart:async';

import 'employee.dart';
import 'employee_repository.dart';

class InMemoryEmployeeRepository implements EmployeeRepository {
  final _controller = StreamController<List<Employee>>.broadcast();
  final List<Employee> _items;

  InMemoryEmployeeRepository({List<Employee>? seed}) : _items = [...?seed] {
    _emit();
  }

  void _emit() => _controller.add(List<Employee>.unmodifiable(_items));

  @override
  Stream<List<Employee>> watchEmployees() => _controller.stream;

  @override
  Future<void> addEmployee(Employee employee) async {
    final now = DateTime.now();
    _items.insert(
      0,
      Employee(
        id: employee.id.isEmpty
            ? now.microsecondsSinceEpoch.toString()
            : employee.id,
        code: employee.code,
        fullName: employee.fullName,
        dateOfBirth: employee.dateOfBirth,
        email: employee.email,
        phone: employee.phone,
        address: employee.address,
      ),
    );
    _emit();
  }

  @override
  Future<void> updateEmployee(Employee employee) async {
    final index = _items.indexWhere((e) => e.id == employee.id);
    if (index == -1) return;
    _items[index] = employee;
    _emit();
  }

  @override
  Future<void> deleteEmployee(String id) async {
    _items.removeWhere((e) => e.id == id);
    _emit();
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
