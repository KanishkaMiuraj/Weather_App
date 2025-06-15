import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../Services/weather_service.dart';
import '../Models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Weather? _weather;
  String _cityName = 'Fetching location...'; // Initial placeholder for city name
  String _windSpeedWithRandomDecimal = ''; // Wind speed with random decimal

  final WeatherService _weatherService = WeatherService();
  late Timer _windSpeedTimer;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  void dispose() {
    _windSpeedTimer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Fetch weather and location data
  Future<void> fetchWeather() async {
    try {
      var location = await _weatherService.getCurrentLocation();
      var weather = await _weatherService.getWeather(
        location['latitude'],
        location['longitude'],
      );

      setState(() {
        _weather = weather;
        _cityName = location['city'] ?? 'Unknown City'; // Update city name here
      });

      // Start the timer to update wind speed decimal value randomly
      _startWindSpeedTimer();
    } catch (e) {
      print("Error fetching weather: $e");
      setState(() {
        _cityName = 'Error fetching location'; // Handle error state
      });
    }
  }

  // Map weather codes to animations
  String getAnimationForWeatherCode(int weatherCode) {
    if (weatherCode == 4) {
      return 'assets/Overcast.json'; // Overcast weather
    } else if (weatherCode >= 1 && weatherCode <= 3) {
      return 'assets/Sunny-1.json'; // Sunny/clear weather
    } else if (weatherCode >= 45 && weatherCode <= 48) {
      return 'assets/Foggy-7.json'; // Foggy
    } else if (weatherCode >= 51 && weatherCode <= 67) {
      return 'assets/Rain-4.json'; // Drizzle
    } else if (weatherCode >= 71 && weatherCode <= 77) {
      return 'assets/Snow-6.json'; // Snow
    } else if (weatherCode >= 80 && weatherCode <= 82) {
      return 'assets/Showers-5.json'; // Rain showers
    } else if (weatherCode >= 95 && weatherCode <= 99) {
      return 'assets/Storm-3.json'; // Thunderstorm
    } else {
      return 'assets/Default.json'; // Default animation
    }
  }

  // Start a timer to update the wind speed's displayed decimal value
  void _startWindSpeedTimer() {
    _windSpeedTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // Generate a random decimal (0 to 9) to append to the original wind speed
        _windSpeedWithRandomDecimal = '${_weather!.windSpeed.toStringAsFixed(0)}.${(0 + (9 * (100 - 1))).round()}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _weather == null
            ? CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center all content vertically
            children: [
              Text(
                _cityName, // Display city name here
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Lottie.asset(
                getAnimationForWeatherCode(_weather!.weatherCode),
                height: 250, // Increased animation size
                width: 250,
              ),
              SizedBox(height: 30),
              _buildWeatherCard(
                icon: Icons.thermostat,
                title: 'Temperature',
                value: '${_weather!.temperature.toStringAsFixed(1)}°C',
                color: Colors.orangeAccent,
              ),
              _buildWeatherCard(
                icon: Icons.water_drop,
                title: 'Humidity',
                value: '${_weather!.humidity.toStringAsFixed(1)}%',
                color: Colors.blueAccent,
              ),
              _buildWeatherCard(
                icon: Icons.wind_power,
                title: 'Wind Speed',
                value: _windSpeedWithRandomDecimal.isEmpty
                    ? '${_weather!.windSpeed.toStringAsFixed(1)} m/s' // Default wind speed value
                    : '$_windSpeedWithRandomDecimal m/s', // Wind speed with random decimal
                color: Colors.lightGreen,
              ),
              _buildWeatherCard(
                icon: Icons.explore,
                title: 'Wind Direction',
                value: _weather!.getWindDirection(),
                color: Colors.purpleAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build weather cards
  Widget _buildWeatherCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}
