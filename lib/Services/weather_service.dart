import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../Models/weather_model.dart';

class WeatherService {
  static const BASE_URL = "https://api.open-meteo.com/v1/forecast"; // Open-Meteo API URL

  // Fetch current weather data
  Future<Weather> getWeather(double latitude, double longitude) async {
    try {
      final response = await http.get(
        Uri.parse(
          "$BASE_URL?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,is_day,precipitation,rain,showers,weather_code,wind_speed_10m,wind_direction_10m",
        ),
      );

      // Log the response body for debugging
      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        // Log the error status code
        print("API Error: ${response.statusCode}");
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      // Log the error
      print("Error: $e");
      throw Exception('Failed to load weather data');
    }
  }

  // Fetch current location (latitude, longitude) and city name
  Future<Map<String, dynamic>> getCurrentLocation() async {
    // Get permission to access location
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Fetch current position (latitude and longitude)
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Convert coordinates into a city name
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks[0].locality;
    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'city': city ?? 'Unknown City',
    };
  }
}
