import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ku360/components/text.dart';
import 'package:ku360/provider/onBoarding/on_boarding_notifier.dart';
import 'package:ku360/provider/onBoarding/on_boarding_provider.dart';

class SchoolPage extends ConsumerStatefulWidget {
  const SchoolPage({super.key});

  @override
  ConsumerState<SchoolPage> createState() => _SchoolPageState();
}

class _SchoolPageState extends ConsumerState<SchoolPage> {
  @override
  Widget build(BuildContext context) {
    final allSchools = ref.watch(schoolsProvider);
    final selectedSchool = ref.watch(schoolNotifierProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 200),
            const Align(
              alignment: Alignment.center,
              child: MyText(
                text: "School?",
                size: 22,
              ),
            ),
            const SizedBox(height: 80),
            Expanded(
              child: ListView.builder(
                itemCount: allSchools.length,
                itemBuilder: (context, index) {
                  final currentSchool = allSchools[index];
                  return ListTile(
                    onTap: () {
                      ref
                          .read(schoolNotifierProvider.notifier)
                          .add(currentSchool);
                    },
                    leading: const Icon(Icons.school),
                    title: MyText(text: currentSchool.name, size: 18),
                    subtitle: Text(currentSchool.shortName),
                    trailing: selectedSchool == currentSchool
                        ? const Icon(Icons.check)
                        : const Icon(Icons.check_box_outline_blank),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
