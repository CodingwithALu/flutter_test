import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  const Employee({
    this.id = '',
    required this.fullName,
    required this.dateOfBirth,
    required this.email,
    required this.phone,
    required this.address,
  });

  final String? id;
  final String fullName;
  final DateTime dateOfBirth;
  final String email;
  final String phone;
  final String address;
  factory Employee.empty() => Employee(
    id: null,
    fullName: '',
    dateOfBirth: DateTime(2000, 1, 1),
    email: '',
    phone: '',
    address: '',
  );

  factory Employee.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    if (data == null) return Employee.empty();
    final dobValue = data['dateOfBirth'];
    final dob = (dobValue is Timestamp)
        ? dobValue.toDate()
        : DateTime.tryParse(dobValue?.toString() ?? '') ?? DateTime(2000, 1, 1);
    return Employee(
      id: document.id,
      fullName: (data['fullName'] ?? '').toString(),
      dateOfBirth: dob,
      email: (data['email'] ?? '').toString(),
      phone: (data['phone'] ?? '').toString(),
      address: (data['address'] ?? '').toString(),
    );
  }

  static Employee fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Employee document ${doc.id} has no data');
    }
    final dobValue = data['dateOfBirth'];
    final dob = (dobValue is Timestamp)
        ? dobValue.toDate()
        : DateTime.tryParse(dobValue?.toString() ?? '') ?? DateTime(2000, 1, 1);
    return Employee(
      id: doc.id,
      fullName: (data['fullName'] ?? '').toString(),
      dateOfBirth: dob,
      email: (data['email'] ?? '').toString(),
      phone: (data['phone'] ?? '').toString(),
      address: (data['address'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson({required bool isNew}) {
    return {
      'fullName': fullName,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'email': email,
      'phone': phone,
      'address': address,
      'updatedAt': FieldValue.serverTimestamp(),
      if (isNew) 'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
