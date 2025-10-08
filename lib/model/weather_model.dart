class Weather{
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final int sunRise;
  final int SunSet;



  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.sunRise,
    required this.SunSet,
});


  factory Weather.fromJson(Map<String, dynamic> json){
    final weatherList = json['weather'] as List<dynamic>;
    final description = (weatherList.isNotEmpty
        ? (weatherList.first as Map<String, dynamic>)['description']
        : '') as String;

    final main = json['main'] as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>;
    final sys = json['sys'] as Map<String, dynamic>;

    final tempKelvin = (main['temp'] as num).toDouble();
    final humidity = (main['humidity'] as num).toInt();
    final windSpeed = (wind['speed'] as num).toDouble();
    final sunrise = (sys['sunrise'] as num).toInt();
    final sunset = (sys['sunset'] as num).toInt();

    return Weather(
      cityName: json['name'] as String,
      temperature: tempKelvin - 273.15,
      description: description,
      humidity: humidity,
      windSpeed: windSpeed,
      sunRise: sunrise,
      SunSet: sunset,
    );
  }
}