import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('SmartContainer');
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    String firstName = _user?.displayName?.split(' ').first ?? 'User';
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF111B21) : const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text('Hi, $firstName 👋', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: isDarkMode ? Colors.white : Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: _dbRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
            return const Center(child: Text('No data available'));
          }

          final data = Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map);

          final double bmpTemp = (data['BMP_Temperature'] ?? 0.0).toDouble();
          final double dhtTemp = (data['DHT_Temperature'] ?? 0.0).toDouble();
          final int gasValue = (data['GasValue'] ?? 0).toInt();
          final double pressure = (data['Pressure'] ?? 0.0).toDouble();
          final double weight = (data['Weight'] ?? 0.0).toDouble().abs();
          final int humidity = (data['Humidity'] ?? 0).toInt();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSystemStatusCard(weight, isDarkMode).animate().fade(duration: 600.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
                const SizedBox(height: 24),
                Text(
                  'Overview',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87),
                ).animate().fade(delay: 200.ms).slideX(begin: -0.1, end: 0),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    _buildPremiumCard(
                      title: 'Gas Level',
                      value: '$gasValue',
                      unit: 'ppm',
                      icon: Icons.cloud,
                      colors: [const Color(0xFFF59E0B), const Color(0xFFD97706)],
                    ),
                    _buildPremiumCard(
                      title: 'Weight',
                      value: weight.toStringAsFixed(2),
                      unit: 'kg',
                      icon: Icons.monitor_weight,
                      colors: [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
                    ),
                    _buildPremiumCard(
                      title: 'BMP Temp',
                      value: bmpTemp.toStringAsFixed(1),
                      unit: '°C',
                      icon: Icons.thermostat,
                      colors: [const Color(0xFFEF4444), const Color(0xFFDC2626)],
                    ),
                    _buildPremiumCard(
                      title: 'DHT Temp',
                      value: dhtTemp.toStringAsFixed(1),
                      unit: '°C',
                      icon: Icons.device_thermostat,
                      colors: [const Color(0xFFF97316), const Color(0xFFEA580C)],
                    ),
                    _buildPremiumCard(
                      title: 'Pressure',
                      value: pressure.toStringAsFixed(0),
                      unit: 'hPa',
                      icon: Icons.compress,
                      colors: [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
                    ),
                    _buildPremiumCard(
                      title: 'Humidity',
                      value: '$humidity',
                      unit: '%',
                      icon: Icons.water_drop,
                      colors: [const Color(0xFF10B981), const Color(0xFF059669)],
                    ),
                  ].animate(interval: 100.ms).fade(duration: 500.ms).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPremiumCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required List<Color> colors,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors[1].withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    unit,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSystemStatusCard(double weight, bool isDarkMode) {
    // Assuming max weight is 10kg
    double fillPercentage = (weight / 10.0).clamp(0.0, 1.0);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1F2C34) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: fillPercentage,
                  backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  color: fillPercentage > 0.8 ? Colors.red : const Color(0xFF00A884),
                  strokeWidth: 8,
                ),
                Center(
                  child: Text(
                    '${(fillPercentage * 100).toInt()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bin Fill Level',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fillPercentage > 0.8
                      ? 'Bin is almost full. Needs collection!'
                      : 'Plenty of space available.',
                  style: TextStyle(
                    color: fillPercentage > 0.8 ? Colors.red : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
