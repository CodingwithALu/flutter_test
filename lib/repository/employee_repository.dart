import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test/utils/exceptions/firebase_exceptions.dart';
import 'package:test/utils/exceptions/format_exceptions.dart';
import 'package:test/utils/exceptions/platform_exceptions.dart';
import '../models/employee_model.dart';

class EmployeeRepository extends GetxController {
  static EmployeeRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  // fetch employee width page
  Future<List<Employee>> fetchEmployeeWidthPages(int page, int pageSize) async {
    try {
      if (page < 1) throw const FormatException('page must be >= 1');
      if (pageSize < 1) throw const FormatException('pageSize must be >= 1');
      final baseQuery = _db
          .collection('Employees')
          .orderBy('createdAt', descending: true);
      if (page == 1) {
        final snapshot = await baseQuery.limit(pageSize).get();
        return snapshot.docs.map(Employee.fromSnapshot).toList();
      }
      final prevSnapshot = await baseQuery.limit((page - 1) * pageSize).get();
      if (prevSnapshot.docs.isEmpty) return <Employee>[];

      final lastDoc = prevSnapshot.docs.last;
      final snapshot = await baseQuery
          .startAfterDocument(lastDoc)
          .limit(pageSize)
          .get();
      return snapshot.docs.map(Employee.fromSnapshot).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong! Please try agian';
    }
  }

  Future<List<Employee>> searchEmployees(String text, {int limit = 20}) async {
    try {
      final q = text.trim().toLowerCase();
      if (q.isEmpty) return fetchEmployeeWidthPages(1, limit);

      Future<List<Employee>> queryBy(String field, int remaining) async {
        final snapshot = await _db
            .collection('Employees')
            .orderBy(field)
            .startAt([q])
            .endAt(['$q\uf8ff'])
            .limit(remaining)
            .get();

        return snapshot.docs.map(Employee.fromSnapshot).toList();
      }

      final Map<String, Employee> merged = {};
      final fields = ['fullNameLower', 'codeLower', 'emailLower', 'phoneLower'];

      for (final field in fields) {
        final remaining = limit - merged.length;
        if (remaining <= 0) break;

        final items = await queryBy(field, remaining);
        for (final e in items) {
          final key = e.id;
          if (key == null || key.trim().isEmpty) continue;
          merged[key] = e;
        }
      }
      return merged.values.toList(growable: false);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong! Please try again';
    }
  }

  Future<String> createEmployee(Employee employee, bool isNew) async {
    try {
      final result = await _db
          .collection('Employees')
          .add(employee.toJson(isNew: isNew));
      return result.id;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw TFormatException(e.message);
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'something went wrong. Please try again';
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    try {
      final id = employee.id;
      if (id == null || id.trim().isEmpty) {
        throw const FormatException('Employee id is required for update');
      }
      await _db
          .collection('Employees')
          .doc(id)
          .set(employee.toJson(isNew: false), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw TFormatException(e.message);
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'something went wrong. Please try again';
    }
  }

  Future<void> deleteEmployee(String id) async {
    try {
      await _db.collection('Employees').doc(id).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'something went wrong. Please try again';
    }
  }
}
