import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  final String city;
  const WeatherScreen({required this.city, super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;
  int humidity = 0;
  double windspeed = 0;
  int pressure = 0;
  String weathercondition = '';
  String cityname = '';
  bool isLoading = false;

  Future<void> getWeather(String cityname) async {
    try {
      setState(() {
        isLoading = true;
      });
      final apikey = '429fe6c2a4e8b682c98b1afc04bcf293';

      final response = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?q=$cityname&APPID=$apikey'),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          temp = (data['main']['temp'] - 273);
          humidity = (data['main']['humidity']);
          windspeed = (data['wind']['speed']);
          pressure = (data['main']['pressure']);
          weathercondition = (data['weather'][0]['description']);
        });
      } else {
        print("There's an error");
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getWeather(widget.city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Weather",
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              getWeather(widget.city);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.refresh,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : widget.city.isEmpty
              ? Center(
                  child: Text(
                  "Please Enter a City",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Current Weather of ${widget.city.toUpperCase()}",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Card(
                        color: Colors.lightBlue[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              WeatherInfoRow(
                                icon: Icons.thermostat_outlined,
                                label: 'Temperature',
                                value: '${temp.toStringAsFixed(2)}°C',
                              ),
                              WeatherInfoRow(
                                icon: Icons.opacity,
                                label: 'Humidity',
                                value: '$humidity%',
                              ),
                              WeatherInfoRow(
                                icon: Icons.air,
                                label: 'Wind Speed',
                                value: '${windspeed.toStringAsFixed(2)} km/h',
                              ),
                              WeatherInfoRow(
                                icon: Icons.speed,
                                label: 'Pressure',
                                value: '$pressure hPa',
                              ),
                              WeatherInfoRow(
                                icon: Icons.cloud,
                                label: 'Condition',
                                value: weathercondition,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class WeatherInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherInfoRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
