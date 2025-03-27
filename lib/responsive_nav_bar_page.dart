import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';
import 'package:paramedic_app/confirm_route_screen.dart';

class ResponsiveNavBarPage extends StatefulWidget {
  final String hospitalName;
  final double hospitalLat;
  final double hospitalLng;

  ResponsiveNavBarPage({
    Key? key,
    required this.hospitalName,
    required this.hospitalLat,
    required this.hospitalLng,
  }) : super(key: key);

  @override
  _ResponsiveNavBarPageState createState() => _ResponsiveNavBarPageState();
}

class _ResponsiveNavBarPageState extends State<ResponsiveNavBarPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<LatLng> _routeCoords = [];
  final String apiKey = "OPENROUTESERVICE_API_KEY";
  final LatLng _currentLocation = LatLng(13.0827, 80.2707);
  double _zoomLevel = 12;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getRoute();
  }

  Future<void> _getRoute() async {
    String url =
        "https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${_currentLocation.longitude},${_currentLocation.latitude}&end=${widget.hospitalLng},${widget.hospitalLat}";

    try {
      var response = await Dio().get(url);
      if (response.statusCode == 200) {
        List<dynamic> coords =
            response.data["routes"][0]["geometry"]["coordinates"];
        List<LatLng> points =
            coords.map((coord) => LatLng(coord[1], coord[0])).toList();
        setState(() {
          _routeCoords = points;
        });
      }
    } catch (e) {
      print("Error fetching route: $e");
    }
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel + 1).clamp(3, 18);
      _mapController.move(_mapController.center, _zoomLevel);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel - 1).clamp(3, 18);
      _mapController.move(_mapController.center, _zoomLevel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Hospital Finder")),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(center: _currentLocation, zoom: _zoomLevel),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routeCoords,
                    strokeWidth: 4.0,
                    color: Colors.blue,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation,
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  Marker(
                    point: LatLng(widget.hospitalLat, widget.hospitalLng),
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.local_hospital,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 100,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _zoomIn,
                  mini: true,
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _zoomOut,
                  mini: true,
                  child: Icon(Icons.remove),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Back to Selection"),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConfirmRouteScreen()),
          );
        },
        child: Icon(Icons.local_hospital),
      ),
    );
  }
}
