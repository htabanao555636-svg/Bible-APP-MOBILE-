import 'package:flutter/material.dart';
import 'package:bible_app/app/app_icons.dart';
import 'package:bible_app/screens/auth/login_screen.dart';
import 'package:bible_app/screens/onboarding/onboarding_flow.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final AnimationController _pulse;

  late final Animation<double> _iconFade;
  late final Animation<double> _iconScale;
  late final Animation<double> _titleAnim;
  late final Animation<double> _taglineAnim;
  late final Animation<double> _buttonsAnim;

  @override
  void initState() {
    super.initState();

    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _iconFade = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );
    _iconScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _entrance,
        curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
      ),
    );
    _titleAnim = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.35, 0.7, curve: Curves.easeOut),
    );
    _taglineAnim = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
    );
    _buttonsAnim = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    );

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _entrance.forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _pulse.dispose();
    super.dispose();
  }

  Widget _fadeSlide(Animation<double> anim, Widget child, {double dy = 0.15}) {
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(begin: Offset(0, dy), end: Offset.zero)
            .animate(anim),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF16241F), Color(0xFF1F4C3B), Color(0xFFCE8B5C)],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  FadeTransition(
                    opacity: _iconFade,
                    child: ScaleTransition(
                      scale: _iconScale,
                      child: AnimatedBuilder(
                        animation: _pulse,
                        builder: (context, child) {
                          final glow = 0.35 + (_pulse.value * 0.25);
                          final scale = 1.0 + (_pulse.value * 0.05);
                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFFC966).withOpacity(glow),
                                    blurRadius: 40,
                                    spreadRadius: 6,
                                  ),
                                ],
                              ),
                              child: const Icon(AppIcons.bible, size: 64, color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _fadeSlide(
                    _titleAnim,
                    const Text(
                      'BibleBayan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _fadeSlide(
                    _taglineAnim,
                    const Text(
                      'Read. Reflect. Grow.',
                      style: TextStyle(color: Colors.white70, fontSize: 16, letterSpacing: 0.3),
                    ),
                  ),
                  const Spacer(flex: 3),
                  _fadeSlide(
                    _buttonsAnim,
                    Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF1F4C3B),
                            minimumSize: const Size(double.infinity, 54),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const OnboardingFlow()),
                            );
                          },
                          child: const Text('Get Started'),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          },
                          child: const Text('Log In', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
