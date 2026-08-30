import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/iot_database_service.dart';

class GpsScreen extends StatefulWidget {
  const GpsScreen({super.key});

  @override
  State<GpsScreen> createState() => _GpsScreenState();
}

class _GpsScreenState extends State<GpsScreen> {
  final IotDatabaseService _iotDb = IotDatabaseService();
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GPS Tracking',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Container position and route handoff.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              
              // Map Card
              Expanded(
                child: StreamBuilder<Map<String, dynamic>>(
                  stream: _iotDb.getGpsStream(),
                  builder: (context, snapshot) {
                    final data = snapshot.data ?? {};
                    final double lat = double.tryParse(data['latitude']?.toString() ?? '6.0') ?? 6.0;
                    final double lng = double.tryParse(data['longitude']?.toString() ?? '8.0') ?? 8.0;
                    
                    final LatLng currentLocation = LatLng(lat, lng);

                    // Animate map to new location
                    if (_mapController != null) {
                      _mapController!.animateCamera(
                        CameraUpdate.newLatLng(currentLocation),
                      );
                    }

                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A202E), // Surface variant or secondary background
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          // Interactive Map View
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(16),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: const Color(0xFF13232C),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: currentLocation,
                                  zoom: 14.0,
                                ),
                                onMapCreated: (controller) {
                                  _mapController = controller;
                                },
                                markers: {
                                  Marker(
                                    markerId: const MarkerId('container'),
                                    position: currentLocation,
                                    infoWindow: const InfoWindow(title: 'Container Location'),
                                  ),
                                },
                                myLocationButtonEnabled: false,
                                zoomControlsEnabled: false,
                              ),
                            ),
                          ),
                          
                          // Coordinates
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Latitude', style: textTheme.bodyMedium),
                                    Text(lat.toStringAsFixed(6), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Longitude', style: textTheme.bodyMedium),
                                    Text(lng.toStringAsFixed(6), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Open in Maps Button
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.map_rounded, color: colorScheme.surface, size: 20),
                              label: const Text('Open in Maps'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.surface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;
      
    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
