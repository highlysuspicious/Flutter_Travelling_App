import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String city = "Fetching...";
  double temperature = 0.0;
  String description = "";

  List hotels = [];
  List cafes = [];
  List museums = [];
  List parks = [];
  List restaurants = [];
  List others = [];

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchPlaces(double lat, double lon) async {
    const apiKey = '0a039d2df0974db5b16022cd8aeda29a';
    final categories = [
      'catering.cafe',
      'entertainment.museum',
      'leisure.park',
      'accommodation.hotel',
      'catering.restaurant'
    ];
    final url = Uri.parse(
      'https://api.geoapify.com/v2/places?categories=${categories.join(',')}&filter=circle:$lon,$lat,5000&limit=40&apiKey=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final features = data['features'];

      setState(() {
        hotels = [];
        cafes = [];
        museums = [];
        parks = [];
        restaurants = [];
        others = [];

        for (var place in features) {
          final categories = List<String>.from(place['properties']['categories'] ?? []);
          print(categories);

          if (categories.any((c) => c.contains('hotel'))) {
            hotels.add(place);
          } else if (categories.any((c) => c.contains('cafe'))) {
            cafes.add(place);
          } else if (categories.any((c) => c.contains('museum'))) {
            museums.add(place);
          } else if (categories.any((c) => c.contains('park'))) {
            parks.add(place);
          } else if (categories.any((c) => c.contains('restaurant'))) {
            restaurants.add(place);
          } else {
            others.add(place);
          }
        }
      });
    } else {
      print('Failed to load places: ${response.statusCode}');
    }
  }

  Future<void> fetchWeather() async {
    const apiKey = '95fa024f41262994bc9617b93007f194';
    final position = await _getCurrentLocation();

    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        city = data['name'];
        temperature = data['main']['temp'];
        description = data['weather'][0]['description'];
      });

      fetchPlaces(position.latitude, position.longitude);
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error("Location permissions are denied");
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Widget buildPlaceSection(String title, List places) {
    if (places.isEmpty) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...places.map((place) {
          final props = place['properties'];
          final name = props['name'] ?? 'Unnamed Place';
          final address = props['formatted'] ?? 'No address available';
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal.shade100,
                child: Icon(Icons.place, color: Colors.teal.shade900),
              ),
              title: Text(name, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              subtitle: Text(address, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
            ),
          );
        }).toList(),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        title: Text("WanderLog", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.teal, Colors.teal.shade200]),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.cloud, color: Colors.white, size: 40),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$city', style: GoogleFonts.poppins(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600)),
                      Text('${temperature.toStringAsFixed(1)}°C • $description', style: GoogleFonts.poppins(color: Colors.white70)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text("Nearby Places", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            buildPlaceSection("Hotels", hotels),
            buildPlaceSection("Cafés", cafes),
            buildPlaceSection("Restaurants", restaurants),
            buildPlaceSection("Museums", museums),
            buildPlaceSection("Parks", parks),
            buildPlaceSection("Others", others),
          ],
        ),
      ),
    );
  }
}
