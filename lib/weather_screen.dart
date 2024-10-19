import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app_flutter/additional_info_item.dart';
import 'package:weather_app_flutter/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_flutter/secret.dart';
import 'package:weather_app_flutter/city_list.dart';
import 'package:weather_app_flutter/city_dropdown.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String selectedCity = 'Karachi'; // Default city
  String currentSky = 'Sunny';
  List<dynamic> hourlyData = [];
  double temp = 0;
  bool isLoading = false;
  late double convert;
  int currentPressure = 1002;
  double currentWindSpeed = 11.3;
  int currentHumidity = 92;

  @override
  void initState() {
    super.initState();
    getCurrenctWeather(selectedCity); // Fetch weather for default city
  }

  Future<void> getCurrenctWeather(String cityName) async {
    try {
      setState(() {
        isLoading = true;
      });
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$APIKEY',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        setState(() {
          isLoading = true;
        });
        throw 'An unexpected error occurred!!';
      }
      hourlyData = data['list'];
      convert = data['list'][0]['main']['temp'];
      currentPressure = data['list'][0]['main']['pressure'];
      currentSky = data['list'][0]['weather'][0]['main'];
      currentWindSpeed = data['list'][0]['wind']['speed'];
      currentHumidity = data['list'][0]['main']['humidity'];
      // Converting Kelvin to Celsius
      setState(() {
        temp = convert - 273.15;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.4,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              getCurrenctWeather(selectedCity);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: // Dropdown for city selection
                  CityDropdown(
                selectedCity: selectedCity,
                cityList: cityList,
                onCityChanged: (String? newCity) {
                  setState(() {
                    selectedCity = newCity!;
                    getCurrenctWeather(
                        selectedCity); // Fetch weather for the selected city
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromRGBO(182, 243, 255, 1),
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 2.2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '${temp.toStringAsFixed(2)}°C',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Icon(
                                  currentSky == 'Clouds' || currentSky == 'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 72,
                                  color: const Color.fromRGBO(182, 243, 255, 1),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  currentSky,
                                  style: const TextStyle(
                                    fontSize: 24,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 10),
            const Center(
              
              child: Text(
                'Hourly Forecast',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                  fontSize: 32,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: hourlyData.length > 5 ? 5 : hourlyData.length,
                itemBuilder: (context, index) {
                  final hrForecast = hourlyData[index];
                  final hrSky = hrForecast['weather'] != null &&
                          hrForecast['weather'].isNotEmpty
                      ? hrForecast['weather'][0]['main']
                      : 'Unknown';
                  final hrTime = DateTime.parse(hrForecast['dt_txt']);
                  final hrTemp = ((hrForecast['main']['temp'] - 273.15).toStringAsFixed(2) + ' °C');
                  return HourlyForecastItem(
                    icon: hrSky == 'Clouds' || hrSky == 'Rain'
                        ? Icons.cloud
                        : Icons.sunny,
                    time: DateFormat.Hm().format(hrTime),
                    temp: hrTemp,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Additional Information',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                  fontSize: 32,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditionalInfoItem(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: currentHumidity.toString(),
                ),
                AdditionalInfoItem(
                  icon: Icons.air_sharp,
                  label: 'Wind speed',
                  value: currentWindSpeed.toString(),
                ),
                AdditionalInfoItem(
                  icon: Icons.beach_access_sharp,
                  label: 'Pressure',
                  value: currentPressure.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
