import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:weather_app/widgets/weather_card.dart';
import 'dart:ui';

import '../model/weather_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherServices _weatherServices = WeatherServices();
  final TextEditingController _controller = TextEditingController();

  bool _isLoading = false;

  Weather? _weather;

  void _getWeather() async {
    final city = _controller.text.trim();
    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a city name')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final weather = await _weatherServices.featchWeather(city);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch weather: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dynamic gradient background
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _buildBackgroundColors(),
              ),
            ),
          ),
          // Subtle circles for depth
          Positioned(
            top: -60,
            right: -40,
            child: _softCircle(180, Colors.white.withOpacity(0.15)),
          ),
          Positioned(
            bottom: -40,
            left: -30,
            child: _softCircle(140, Colors.white.withOpacity(0.12)),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      'Weather APP',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Search bar + button
                    Row(
                      children: [
                        Expanded(
                          child: _glass(
                            child: TextField(
                              controller: _controller,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Search city... ',
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _getWeather,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            backgroundColor: Colors.white.withOpacity(0.35),
                            foregroundColor: const Color(0xFF1B1F23),
                            elevation: 1,
                          ),
                          icon: const Icon(Icons.search),
                          label: const Text('Get Weather'),
                        ),
                      ],
                    ),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                    if (_weather != null)
                      WeatherCard(weather: _weather!),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _buildBackgroundColors(){
    final base = _weather?.description.toLowerCase() ?? '';
    if (base.contains('rain')) {
      return [const Color(0xFF3A6073), const Color(0xFF16222A)];
    }
    if (base.contains('clear')) {
      return [const Color(0xFF56CCF2), const Color(0xFF2F80ED)];
    }
    if (base.contains('snow')) {
      return [const Color(0xFF83a4d4), const Color(0xFFb6fbff)];
    }
    return [const Color(0xFFF2994A), const Color(0xFF2D9CDB)];
  }

  Widget _glass({required Widget child}){
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.28),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _softCircle(double size, Color color){
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
