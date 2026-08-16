import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GpsTab extends StatefulWidget {
  const GpsTab({super.key});

  @override
  State<GpsTab> createState() => _GpsTabState();
}

class _GpsTabState extends State<GpsTab> with SingleTickerProviderStateMixin {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('SmartContainer/GPS');
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  LatLng _currentLocation = const LatLng(6.9271, 79.8612); // Default
  
  // Example Destination (Colombo Port)
  LatLng _destinationLocation = const LatLng(6.9400, 79.8450); 
  
  bool _isFirstLocationUpdate = true;
  late AnimationController _pulseController;
  
  // OSRM Route Data
  double _roadDistanceKm = 0.0;
  List<LatLng> _routePoints = [];
  bool _isLoadingRoute = false;

  Future<void> _fetchRoute(LatLng start, LatLng end) async {
    if (_isLoadingRoute) return;
    setState(() => _isLoadingRoute = true);
    try {
      final url = 'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final routes = data['routes'] as List;
        if (routes.isNotEmpty) {
          final distanceMeters = (routes[0]['distance'] as num).toDouble();
          final geometry = routes[0]['geometry']['coordinates'] as List;
          final List<LatLng> points = geometry.map((coord) => LatLng(coord[1] as double, coord[0] as double)).toList();
          if (mounted) {
            setState(() {
              _roadDistanceKm = distanceMeters / 1000.0;
              _routePoints = points;
            });
          }
        }
      }
    } catch (e) {
      debugPrint("OSRM error: $e");
    } finally {
      if (mounted) setState(() => _isLoadingRoute = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color cardColor = isDarkMode ? const Color(0xFF202C33) : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    Color subtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF111B21) : Colors.white,
      appBar: AppBar(
        title: const Text('Live Route', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: cardColor,
        elevation: 0,
        foregroundColor: textColor,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _dbRef.onValue,
        builder: (context, snapshot) {
          double speed = 0.0;
          String status = "Offline";
          double distanceKm = 0.0;
          
          if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
            final data = Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map);
            final double lat = (data['Latitude'] ?? 0.0).toDouble();
            final double lng = (data['Longitude'] ?? 0.0).toDouble();
            speed = (data['Speed'] ?? 0.0).toDouble(); // Get speed if available
            status = speed > 0 ? "Moving to Destination" : "Parked";
            
            if (lat != 0.0 && lng != 0.0) {
              _currentLocation = LatLng(lat, lng);
              // Calculate distance using latlong2 Distance class
              distanceKm = const Distance().as(LengthUnit.Kilometer, _currentLocation, _destinationLocation).toDouble();

              if (_isFirstLocationUpdate) {
                // Zoom out a bit to show both locations if possible
                _mapController.move(_currentLocation, 10.0);
                _fetchRoute(_currentLocation, _destinationLocation);
                _isFirstLocationUpdate = false;
              }
            }
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentLocation,
                  initialZoom: 10.0,
                  onTap: (tapPosition, point) {
                    setState(() {
                      _destinationLocation = point;
                    });
                    _fetchRoute(_currentLocation, _destinationLocation);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: isDarkMode 
                        ? 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png'
                        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.smart_container_app',
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline<Object>(
                        points: _routePoints.isNotEmpty ? _routePoints : [_currentLocation, _destinationLocation],
                        color: Colors.blue,
                        strokeWidth: 4.0,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      // Destination Marker
                      Marker(
                        point: _destinationLocation,
                        width: 50,
                        height: 50,
                        child: const Icon(Icons.warehouse, color: Colors.orange, size: 40),
                      ),
                      // Current Location Marker
                      Marker(
                        point: _currentLocation,
                        width: 80,
                        height: 80,
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 40 + (_pulseController.value * 20),
                                  height: 40 + (_pulseController.value * 20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue.withOpacity(0.3 - (_pulseController.value * 0.2)),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
                                    ]
                                  ),
                                  child: const Icon(
                                    Icons.local_shipping,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              // Top Search Bars (Google Maps style)
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Current Location (Smart Container Live)
                      Row(
                        children: [
                          const Icon(Icons.my_location, color: Colors.blue, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Live Container Location",
                                    style: TextStyle(color: textColor, fontWeight: FontWeight.w500, fontSize: 14),
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: 8, height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: status == "Moving to Destination" ? Colors.green : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Destination Search Bar
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.red, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: _searchController,
                                style: TextStyle(color: textColor, fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: "Search Destination or Tap on map...",
                                  hintStyle: TextStyle(color: subtitleColor, fontSize: 14),
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.search, color: Colors.blue),
                                    onPressed: () {
                                      FocusScope.of(context).unfocus(); // Close keyboard
                                      _searchDestination(_searchController.text);
                                    },
                                  ),
                                ),
                                onSubmitted: (value) => _searchDestination(value),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Telemetry Card
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        _mapController.move(_currentLocation, 14.0);
                      },
                      backgroundColor: cardColor,
                      child: Icon(Icons.my_location, color: textColor),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 8))
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildTelemetryData('Speed', '${speed.toStringAsFixed(1)} km/h', Icons.speed, Colors.blue, textColor, subtitleColor),
                          Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
                          _buildTelemetryData('To Dest', '${(_roadDistanceKm > 0 ? _roadDistanceKm : distanceKm).toStringAsFixed(1)} km', Icons.route, Colors.orange, textColor, subtitleColor),
                          Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
                          _buildTelemetryData('ETA', _formatEta(_roadDistanceKm > 0 ? _roadDistanceKm : distanceKm, speed), Icons.access_time, Colors.purple, textColor, subtitleColor),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatEta(double distanceKm, double speed) {
    if (distanceKm == 0) return "0m";
    double timeInHours = distanceKm / (speed > 0 ? speed : 40); // default to 40 km/h if stopped
    int hours = timeInHours.floor();
    int minutes = ((timeInHours - hours) * 60).round();
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  Future<void> _searchDestination(String query) async {
    if (query.isEmpty) return;
    try {
      final response = await http.get(
        Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1'),
        headers: {'User-Agent': 'SmartContainerApp'},
      );
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as List;
        if (jsonResponse.isNotEmpty) {
          final lat = double.parse(jsonResponse[0]['lat']);
          final lon = double.parse(jsonResponse[0]['lon']);
          setState(() {
            _destinationLocation = LatLng(lat, lon);
          });
          _mapController.move(_destinationLocation, 14.0);
        }
      }
    } catch (e) {
      debugPrint("Search failed: $e");
    }
  }

  Widget _buildTelemetryData(String label, String value, IconData icon, Color iconColor, Color textColor, Color subtitleColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: subtitleColor),
        ),
      ],
    );
  }
}
