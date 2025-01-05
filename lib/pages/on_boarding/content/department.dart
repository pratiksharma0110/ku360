import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ku360/components/dropdown.dart';

import 'package:ku360/components/text.dart';
import 'package:ku360/provider/on_boarding_notifier.dart';
import 'package:ku360/provider/on_boarding_provider.dart';

class DepartmentPage extends ConsumerStatefulWidget {
  const DepartmentPage({super.key});

  @override
  ConsumerState<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends ConsumerState<DepartmentPage> {
  @override
  Widget build(BuildContext context) {
    final allDepartments = ref.watch(departmentsProvider);
    final selectedDepartment = ref.watch(departmentNotifierProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 200),
            const Align(
              alignment: Alignment.center,
              child: MyText(
                text: "Department?",
                size: 22,
              ),
            ),
            const SizedBox(height: 20),
            MyDropdown(
              prefixIcon: Icon(Icons.school),
              items: allDepartments.map((dept) => dept.name).toList(),
              value: selectedDepartment.name,
              onChanged: (value) {
                final selectedDept = allDepartments.firstWhere(
                  (dept) => dept.name == value,
                );
                ref.read(departmentNotifierProvider.notifier).add(selectedDept);
              },
            ),
          ],
        ),
      ),
    );
  }
}
