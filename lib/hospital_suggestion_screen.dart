import 'package:flutter/material.dart';
import 'responsive_nav_bar_page.dart'; // Ensure this is the correct import path

class HospitalSuggestionScreen extends StatelessWidget {
  final String issue;

  final Map<String, Map<String, dynamic>> hospitalData = {
    "Cardiac Arrest": {
      "name": "Apollo Hospital",
      "lat": 13.0674,
      "lng": 80.2376,
    },
    "Diabetes": {"name": "Fortis Hospital", "lat": 12.9716, "lng": 77.5946},
    "Neurology": {"name": "Global Hospital", "lat": 13.0074, "lng": 80.2707},
    "Fracture": {"name": "MIOT Hospital", "lat": 13.0098, "lng": 80.2113},
    "Cancer": {"name": "AIIMS Hospital", "lat": 28.5672, "lng": 77.2100},
  };

  HospitalSuggestionScreen({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    var hospital =
        hospitalData[issue] ??
        {"name": "General Hospital", "lat": 13.0827, "lng": 80.2707};

    return Scaffold(
      appBar: AppBar(title: Text("Suggested Hospital")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Recommended Hospital:", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
              hospital["name"],
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ResponsiveNavBarPage(
                          hospitalName: hospital["name"],
                          hospitalLat: hospital["lat"],
                          hospitalLng: hospital["lng"],
                        ),
                  ),
                );
              },
              child: Text("View Route"),
            ),
          ],
        ),
      ),
    );
  }
}
