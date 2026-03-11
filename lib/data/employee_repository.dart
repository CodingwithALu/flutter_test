import 'employee.dart';

abstract class EmployeeRepository {
  Stream<List<Employee>> watchEmployees();
  Future<void> addEmployee(Employee employee);
  Future<void> updateEmployee(Employee employee);
  Future<void> deleteEmployee(String id);
}
