import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/weather_model.dart';
import 'package:lottie/lottie.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key, required this.weather});
  final Weather weather;

String formatTime(int timestemp){
  // OpenWeatherMap provides UNIX time in seconds
  final date = DateTime.fromMillisecondsSinceEpoch(timestemp * 1000, isUtc: true).toLocal();
  return DateFormat('hh:mm a').format(date);
}

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.95, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, scale, _) {
        return Transform.scale(
          scale: scale,
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.55), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Weather animation
            Builder(
              builder: (_) {
                final desc = weather.description.toLowerCase();
                final assetPath = desc.contains('rain')
                    ? 'assets/rain.json'
                    : desc.contains('clear')
                        ? 'assets/sunny.json'
                        : desc.contains('snow')
                            ? 'assets/snowfall.json'
                            : 'assets/cloudy.json';
                return Lottie.asset(
                  assetPath,
                  height: 160,
                  width: 160,
                  errorBuilder: (context, error, stack) => const Icon(
                    Icons.cloud,
                    size: 150,
                    color: Colors.white70,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                colors: [Color(0xFFFFFFFF), Color(0xFFE0ECFF)],
              ).createShader(rect),
              child: Text(
                weather.cityName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${weather.temperature.toStringAsFixed(1)}°C',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              weather.description,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _metricTile(context, Icons.water_drop, 'Humidity', '${weather.humidity}%'),
                _metricTile(context, Icons.air, 'Wind', '${weather.windSpeed.toStringAsFixed(1)} m/s'),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _sunTile(context, 'Sunrise', formatTime(weather.sunRise)),
                _sunTile(context, 'Sunset', formatTime(weather.SunSet)),
              ],
            ),
          ],
        ),
            ),
          ),
        );
      },
    );
  }

  Widget _metricTile(BuildContext context, IconData icon, String label, String value){
    return Row(
      children: [
        Icon(icon, color: Colors.amberAccent),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
            Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _sunTile(BuildContext context, String label, String time){
    return Column(
      children: [
        const Icon(Icons.wb_sunny_outlined, color: Colors.orangeAccent),
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
        Text(time, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
      ],
    );
  }
}
