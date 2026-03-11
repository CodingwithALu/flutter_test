import 'package:flutter/material.dart';

import '../models/employee_model.dart';
import '../repository/employee_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repo = EmployeeRepository();
  final _controller = TextEditingController();

  Future<List<Employee>>? _searchFuture;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final q = value.trim();
    setState(() {
      _searchFuture = q.isEmpty ? null : _repo.searchEmployees(q, limit: 50);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tìm kiếm nhân sự')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Nhập mã / tên / email / SĐT',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: _onChanged,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _searchFuture == null
                    ? const Center(child: Text('Nhập từ khóa để tìm kiếm'))
                    : FutureBuilder<List<Employee>>(
                        future: _searchFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Lỗi: ${snapshot.error}'),
                            );
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final items = snapshot.data!;
                          if (items.isEmpty) {
                            return const Center(
                              child: Text('Không tìm thấy kết quả'),
                            );
                          }

                          return ListView.separated(
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final e = items[index];
                              final subtitleParts = <String>[];
                              if (e.email.trim().isNotEmpty) {
                                subtitleParts.add(e.email.trim());
                              }
                              if (e.phone.trim().isNotEmpty) {
                                subtitleParts.add(e.phone.trim());
                              }

                              return ListTile(
                                title: Text(e.fullName),
                                subtitle: subtitleParts.isEmpty
                                    ? null
                                    : Text(subtitleParts.join(' • ')),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
