import 'package:cloud_firestore/cloud_firestore.dart';

import 'employee.dart';
import 'employee_repository.dart';

class FirestoreEmployeeRepository implements EmployeeRepository {
  FirestoreEmployeeRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('employees');

  @override
  Stream<List<Employee>> watchEmployees() {
    return _col
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Employee.fromDoc).toList());
  }

  @override
  Future<void> addEmployee(Employee employee) {
    return _col.add(employee.toFirestoreMap(isNew: true));
  }

  @override
  Future<void> updateEmployee(Employee employee) {
    return _col
        .doc(employee.id)
        .set(employee.toFirestoreMap(isNew: false), SetOptions(merge: true));
  }

  @override
  Future<void> deleteEmployee(String id) {
    return _col.doc(id).delete();
  }
}
