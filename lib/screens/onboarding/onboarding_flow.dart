import 'package:flutter/material.dart';
import 'package:bible_app/app/theme.dart';
import 'package:bible_app/screens/onboarding/onboarding_1.dart';
import 'package:bible_app/screens/onboarding/onboarding_2.dart';
import 'package:bible_app/screens/onboarding/onboarding_3.dart';
import 'package:bible_app/screens/auth/signup_screen.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final _controller = PageController();
  int _page = 0;

  final _pages = const [Onboarding1(), Onboarding2(), Onboarding3()];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToSignup() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
  }

  void _next() {
    if (_page == _pages.length - 1) {
      _goToSignup();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: Align(
                alignment: Alignment.centerRight,
                child: isLast
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: TextButton(
                          onPressed: _goToSignup,
                          child: Text('Skip', style: TextStyle(color: AppColors.textMuted)),
                        ),
                      ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      var page = index.toDouble();
                      if (_controller.hasClients && _controller.page != null) {
                        page = _controller.page!;
                      }
                      final delta = page - index;
                      final scale = (1 - delta.abs() * 0.2).clamp(0.85, 1.0);
                      final opacity = (1 - delta.abs() * 0.8).clamp(0.3, 1.0);
                      return Opacity(
                        opacity: opacity,
                        child: Transform.scale(scale: scale, child: child),
                      );
                    },
                    child: _pages[index],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _page ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _page
                        ? AppColors.primaryGreen
                        : AppColors.primaryGreen.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: _next,
                child: Text(isLast ? 'Get Started' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
