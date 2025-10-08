import 'package:http/http.dart' as http;
import '../model/weather_model.dart';
import 'dart:convert';




class WeatherServices{

  final String apiKey= 'f68be4ef737f54fa75905cccf9b890e4';
  
  Future<Weather> featchWeather(String cityName) async {
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey');
    final response = await http.get(url);

    if(response.statusCode ==200){
      return Weather.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Failed to load weather data');
    }
  }
}