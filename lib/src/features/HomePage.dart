import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String city = "Fetching...";
  double temperature = 0.0;
  String description = "";
  List nearbyPlaces = [];

  @override
  void initState() {
    super.initState();
    fetchWeather();
    fetchNearbyPlaces();
  }

  Future<void> fetchWeather() async {
    const apiKey = '';
    const lat = '28.6139';
    const lon = '77.2090';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        city = data['name'];
        temperature = data['main']['temp'];
        description = data['weather'][0]['description'];
      });
    }
  }

  Future<void> fetchNearbyPlaces() async {
    const apiKey = '';
    const lat = '28.6139';
    const lon = '77.2090';
    const radius = '5000';
    final url =
        'https://api.opentripmap.com/0.1/en/places/radius?radius=$radius&lon=$lon&lat=$lat&apikey=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        nearbyPlaces = data['features'].take(10).toList(); // Limit to 10
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.cloud),
                title: Text('$city • ${temperature.toStringAsFixed(1)}°C'),
                subtitle: Text(description),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Nearby Places", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            ...nearbyPlaces.map((place) {
              final name = place['properties']['name'] ?? 'Unnamed Place';
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.place),
                  title: Text(name),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
