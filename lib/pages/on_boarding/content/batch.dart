import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ku360/components/dropdown.dart';
import 'package:ku360/components/text.dart';
import 'package:ku360/provider/on_boarding_notifier.dart';
import 'package:ku360/provider/on_boarding_provider.dart';

class BatchPage extends ConsumerStatefulWidget {
  const BatchPage({super.key});

  @override
  ConsumerState<BatchPage> createState() => _BatchPageState();
}

class _BatchPageState extends ConsumerState<BatchPage> {
  @override
  Widget build(BuildContext context) {
    // Fetch all years and semesters from providers
    final allYears = ref.watch(yearsProvider);
    final allSemesters = ref.watch(semestersProvider);

    // Watch selected year and semester
    final selectedYear = ref.watch(yearNotifierProvider);
    final selectedSemester = ref.watch(semesterNotifierProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 200),
            const Align(
              alignment: Alignment.center,
              child: MyText(
                text: "Year?",
                size: 22,
              ),
            ),
            const SizedBox(height: 20),
            MyDropdown(
              prefixIcon: const Icon(Icons.calendar_today),
              items: allYears.map((year) => year.toString()).toList(),
              value: selectedYear?.toString(),
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(yearNotifierProvider.notifier)
                      .select(int.parse(value));
                }
              },
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.center,
              child: MyText(
                text: "Semester?",
                size: 22,
              ),
            ),
            const SizedBox(height: 20),
            MyDropdown(
              prefixIcon: const Icon(Icons.school),
              items:
                  allSemesters.map((semester) => semester.toString()).toList(),
              value: selectedSemester.toString(),
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(semesterNotifierProvider.notifier)
                      .select(int.parse(value));
                }
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

