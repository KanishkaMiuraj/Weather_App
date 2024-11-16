class Weather {
  final String cityName;
  final double temperature;
  final double humidity;
  final double precipitation;
  final double rain;
  final double windSpeed;
  final double windDirection;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.humidity,
    required this.precipitation,
    required this.rain,
    required this.windSpeed,
    required this.windDirection,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['city'] ?? 'Unknown City',
      temperature: json['current']['temperature_2m']?.toDouble() ?? 0.0,
      humidity: json['current']['relative_humidity_2m']?.toDouble() ?? 0.0,
      precipitation: json['current']['precipitation']?.toDouble() ?? 0.0,
      rain: json['current']['rain']?.toDouble() ?? 0.0,
      windSpeed: json['current']['wind_speed_10m']?.toDouble() ?? 0.0,
      windDirection: json['current']['wind_direction_10m']?.toDouble() ?? 0.0,
    );
  }

  // Method to get wind direction as a string
  String getWindDirection() {
    if (windDirection >= 0 && windDirection < 22.5) {
      return 'North';
    } else if (windDirection >= 22.5 && windDirection < 67.5) {
      return 'North-East';
    } else if (windDirection >= 67.5 && windDirection < 112.5) {
      return 'East';
    } else if (windDirection >= 112.5 && windDirection < 157.5) {
      return 'South-East';
    } else if (windDirection >= 157.5 && windDirection < 202.5) {
      return 'South';
    } else if (windDirection >= 202.5 && windDirection < 247.5) {
      return 'South-West';
    } else if (windDirection >= 247.5 && windDirection < 292.5) {
      return 'West';
    } else if (windDirection >= 292.5 && windDirection < 337.5) {
      return 'North-West';
    } else {
      return 'North';
    }
  }
}
