import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: AppDimensions.splashMs), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home_rounded,
                color: AppColors.homeColor, size: 80)
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 12),
            Text(
              '→',
              style: GoogleFonts.fredoka(
                  fontSize: 40,
                  color: AppColors.accentPurple,
                  fontWeight: FontWeight.w700),
            )
                .animate(delay: 400.ms)
                .moveX(begin: -30, end: 0, duration: 500.ms)
                .fadeIn(),
            const SizedBox(height: 12),
            const Icon(Icons.business_rounded,
                color: AppColors.cisboxColor, size: 80)
                .animate(delay: 800.ms)
                .scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 24),
            Text(
              AppStrings.appTitle,
              style: GoogleFonts.fredoka(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ).animate(delay: 1200.ms).fadeIn(duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
