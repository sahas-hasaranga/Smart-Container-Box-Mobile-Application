import 'package:flutter/material.dart';

import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import '../services/iot_database_service.dart';

class CameraScreen extends StatelessWidget {
  CameraScreen({super.key});

  final IotDatabaseService _iotDb = IotDatabaseService();

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
                'Surveillance',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Security anomaly detected. Review the feed immediately.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              
              // Alert Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A202E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.error.withAlpha(50)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: colorScheme.error, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Critical condition detected',
                      style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Video Player from MJPEG Stream
              Expanded(
                child: Container(
                  width: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A202E),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: StreamBuilder<Map<String, dynamic>>(
                    stream: _iotDb.getCameraInfoStream(),
                    builder: (context, snapshot) {
                      final data = snapshot.data ?? {};
                      final String streamUrl = data['stream_url'] ?? '';

                      if (streamUrl.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.videocam_off,
                              size: 64,
                              color: Colors.white.withAlpha(100),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Camera feed unavailable\n(Set stream_url in Firebase)',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withAlpha(153),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      }

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Mjpeg(
                            isLive: true,
                            stream: streamUrl,
                            fit: BoxFit.cover,
                            error: (context, error, stack) {
                              return Center(
                                child: Text(
                                  'Error loading stream:\n$error',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: colorScheme.error),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            top: 16,
                            left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(150),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: StreamBuilder<DateTime>(
                                stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
                                builder: (context, snapshot) {
                                  final time = snapshot.data ?? DateTime.now();
                                  return Text(
                                    'LIVE | ${time.toString().substring(0, 19)}',
                                    style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.bold, fontSize: 12),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Camera Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    icon: Icons.camera_alt_rounded,
                    label: 'Snapshot',
                    color: colorScheme.secondary,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Snapshot saved to Incident Gallery')),
                      );
                    },
                  ),
                  _buildControlButton(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    color: colorScheme.primary,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening Gallery...')),
                      );
                    },
                  ),
                  _buildControlButton(
                    icon: Icons.emergency_share_rounded,
                    label: 'Report',
                    color: colorScheme.error,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Generating Incident Report...')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
