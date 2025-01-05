import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ku360/pages/home.dart';
import 'package:ku360/pages/on_boarding/content/batch.dart';
import 'package:ku360/pages/on_boarding/content/department.dart';
import 'package:ku360/pages/on_boarding/content/welcome.dart';
import 'package:ku360/pages/on_boarding/content/school.dart';
import 'package:ku360/provider/on_boarding_notifier.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingPage extends ConsumerStatefulWidget {
  const OnBoardingPage({super.key});

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends ConsumerState<OnBoardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _goBack() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linearToEaseOut,
      );
    }
  }

  void _goForward() {
    if (_currentPage < 3) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linearToEaseOut,
      );
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        ref.watch(schoolNotifierProvider);
        ref.watch(departmentNotifierProvider);
        ref.watch(yearNotifierProvider);
        ref.watch(semesterNotifierProvider);

        return Scaffold(
          body: Stack(
            children: [
              PageView(
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                controller: _controller,
                children: const [
                  Welcome(),
                  SchoolPage(),
                  DepartmentPage(),
                  BatchPage(),
                ],
              ),
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SmoothPageIndicator(
                      effect: const ScaleEffect(
                        dotWidth: 8.0,
                        dotHeight: 8.0,
                        activeDotColor: Colors.black,
                        dotColor: Colors.grey,
                      ),
                      controller: _controller,
                      count: 4,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_currentPage > 0)
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: _goBack,
                            iconSize: 24,
                          ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: _goForward,
                          iconSize: 24,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
