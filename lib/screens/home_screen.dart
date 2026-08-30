import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/iot_database_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Live Metrics',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              
              Expanded(
                child: StreamBuilder<Map<String, dynamic>>(
                  stream: _iotDb.getLiveMetricsStream(),
                  builder: (context, snapshot) {
                    final data = snapshot.data ?? {};
                    
                    final String tempStr = data['temperature']?.toString() ?? '40.0';
                    final String humidityStr = data['humidity']?.toString() ?? '70';
                    final String batteryStr = data['battery']?.toString() ?? '40';
                    final String weightStr = data['cargo_weight']?.toString() ?? '50.0';
                    final String gasStr = data['gas_level']?.toString() ?? '5';
                    final String pressureStr = data['pressure']?.toString() ?? '3.0';

                    final double temp = double.tryParse(tempStr) ?? 40.0;
                    final double gas = double.tryParse(gasStr) ?? 5.0;

                    bool isWarning = temp > 45.0 || gas > 10.0;
                    String alertMessage = isWarning ? 'Warning: Critical Threshold Exceeded!' : 'All Systems Normal';
                    Color alertColor = isWarning ? colorScheme.error : colorScheme.primary;

                    return Column(
                      children: [
                        // Status Alert Bar
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: alertColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: alertColor.withAlpha(50)),
                          ),
                          child: Row(
                            children: [
                              Icon(isWarning ? Icons.warning_rounded : Icons.check_circle_rounded, color: alertColor, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                alertMessage,
                                style: TextStyle(color: alertColor, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        
                        // Metrics Grid
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.85,
                            children: [
                              _buildMetricCard(
                                icon: Icons.device_thermostat_rounded,
                                iconColor: colorScheme.primary,
                                iconBgColor: colorScheme.primary.withAlpha(38),
                                value: '$tempStr C',
                                label: 'Temperature',
                                showChart: true,
                                theme: theme,
                              ),
                              _buildMetricCard(
                                icon: Icons.water_drop_rounded,
                                iconColor: colorScheme.secondary,
                                iconBgColor: colorScheme.secondary.withAlpha(38),
                                value: '$humidityStr%',
                                label: 'Humidity',
                                showChart: true,
                                theme: theme,
                              ),
                              _buildMetricCard(
                                icon: Icons.battery_charging_full_rounded,
                                iconColor: const Color(0xFFF59E0B), // keep some distinctive colors for icons
                                iconBgColor: const Color(0xFFF59E0B).withAlpha(38),
                                value: '$batteryStr%',
                                label: 'Battery',
                                showChart: false,
                                theme: theme,
                              ),
                              _buildMetricCard(
                                icon: Icons.all_inbox_rounded,
                                iconColor: colorScheme.primary,
                                iconBgColor: colorScheme.primary.withAlpha(38),
                                value: '$weightStr kg',
                                label: 'Cargo Weight',
                                showChart: false,
                                theme: theme,
                              ),
                              _buildMetricCard(
                                icon: Icons.air_rounded,
                                iconColor: const Color(0xFF0EA5E9),
                                iconBgColor: const Color(0xFF0EA5E9).withAlpha(38),
                                value: '$gasStr ppm',
                                label: 'Gas Level',
                                showChart: true,
                                theme: theme,
                              ),
                              _buildMetricCard(
                                icon: Icons.speed_rounded,
                                iconColor: const Color(0xFF8B5CF6),
                                iconBgColor: const Color(0xFF8B5CF6).withAlpha(38),
                                value: '$pressureStr hPa',
                                label: 'Pressure',
                                showChart: false,
                                theme: theme,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String label,
    required bool showChart,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A202E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              if (showChart)
                SizedBox(
                  width: 50,
                  height: 30,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 3), FlSpot(1, 4), FlSpot(2, 3.5), FlSpot(3, 5), FlSpot(4, 4), FlSpot(5, 6),
                          ],
                          isCurved: true,
                          color: iconColor.withAlpha(150),
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: iconColor.withAlpha(25),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
