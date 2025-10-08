import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather_app/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await precacheImage(const AssetImage('assets/splash_logo.webp'), context);
      } catch (_) {}
      if (!mounted) return;
      Timer(const Duration(seconds: 2), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF2994A), Color(0xFF2D9CDB)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // App logo / splash image
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/splash_logo.webp',
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => const Icon(
                    Icons.cloud,
                    size: 120,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Weather APP',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 12),
              const SizedBox(
                width: 140,
                child: LinearProgressIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.white24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


