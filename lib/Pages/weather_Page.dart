import 'package:flutter/material.dart';
import 'package:weather_app/Models/weather_model.dart';
import 'package:weather_app/Services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  String _cityName = '';
  double _rainChance = 0.0;
  double _temperature = 0.0;
  double _humidity = 0.0;
  double _windSpeed = 0.0;
  double _windDirection = 0.0;

  // Fetch weather data based on current location
  fetchWeather() async {
    try {
      // Get current location
      final location = await _weatherService.getCurrentLocation();
      final latitude = location['latitude'];
      final longitude = location['longitude'];

      // Get current weather for the location
      final weather = await _weatherService.getWeather(latitude, longitude);

      setState(() {
        _weather = weather;
        _cityName = location['city'];
        _rainChance = weather.precipitation;  // Use precipitation for rain chance
        _temperature = weather.temperature;
        _humidity = weather.humidity;
        _windSpeed = weather.windSpeed;
        _windDirection = weather.windDirection;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather in $_cityName'),
        backgroundColor: Colors.blueAccent,
        actions: [
          // Refresh Button
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Call fetchWeather to refresh the data
              fetchWeather();
            },
          ),
        ],
      ),
      body: Center(
        child: _weather == null
            ? CircularProgressIndicator()  // Show loading indicator if data is not fetched
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // City and weather info
              Text(
                'City: $_cityName',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Temperature: ${_temperature.toStringAsFixed(1)}°C',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Humidity: ${_humidity.toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Wind Speed: ${_windSpeed.toStringAsFixed(1)} m/s',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Wind Direction: ${_weather?.getWindDirection()}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),

              // Rain chance for the next 4 hours
              Text(
                'Chance of Rain in next 4 hours: ${(_rainChance * 100).toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
