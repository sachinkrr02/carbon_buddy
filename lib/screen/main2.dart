import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/intensity_provider.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IntensityProvider()),
      ],
      child: MaterialApp(
        title: 'Carbon Intensity Dashboard',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  // Returns a warning based on the carbon intensity
  String _getIntensityWarning(double intensity) {
    if (intensity < 100) {
      return 'Low Carbon Intensity: Great! Continue using energy wisely.';
    } else if (intensity < 200) {
      return 'Moderate Carbon Intensity: Consider reducing energy use during peak times.';
    } else {
      return 'High Carbon Intensity: Warning! Excessive CO₂ emissions. Please reduce energy consumption.';
    }
  }

  // Determines the color of the warning based on intensity
  Color _getWarningColor(double intensity) {
    if (intensity < 100) {
      return Colors.green;
    } else if (intensity < 200) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // Returns an icon based on the intensity
  IconData _getIntensityIcon(double intensity) {
    if (intensity < 100) {
      return Icons.nature;
    } else if (intensity < 200) {
      return Icons.warning;
    } else {
      return Icons.fireplace;
    }
  }

  // Returns a background color for the warning icon based on the intensity
  Color _getIconBackgroundColor(double intensity) {
    if (intensity < 100) {
      return Colors.green.withOpacity(0.2);
    } else if (intensity < 200) {
      return Colors.orange.withOpacity(0.2);
    } else {
      return Colors.red.withOpacity(0.2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[700]!, Colors.green[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text('Carbon Intensity Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<IntensityProvider>(context, listen: false)
                  .fetchData();
            },
          ),
        ],
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<IntensityProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 40),
                    const SizedBox(height: 20),
                    Text(
                      provider.errorMessage!,
                      style: const TextStyle(fontSize: 18, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: provider.fetchData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // Get the current intensity value
            num currentIntensity = provider.currentIntensity ?? 0;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Carbon Intensity Info Section
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'What is Carbon Intensity?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Carbon intensity measures the amount of CO₂ emissions per unit of electricity consumed. '
                            'It is expressed in grams of CO₂ emitted per kilowatt-hour (gCO₂/kWh). '
                            'Lower carbon intensity indicates cleaner, more sustainable energy usage.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Current Carbon Intensity Widget
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Current Carbon Intensity',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            provider.currentIntensity != null
                                ? '${provider.currentIntensity} gCO₂/kWh'
                                : 'N/A',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color:
                                  _getWarningColor(currentIntensity.toDouble()),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Intensity Warning Icon
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _getIconBackgroundColor(
                                      currentIntensity.toDouble()),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getIntensityIcon(
                                      currentIntensity.toDouble()),
                                  color: _getWarningColor(
                                      currentIntensity.toDouble()),
                                  size: 40,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _getIntensityWarning(
                                      currentIntensity.toDouble()),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _getWarningColor(
                                        currentIntensity.toDouble()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Daily Carbon Intensity Graph
                    if (provider.dailyIntensity != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Daily Carbon Intensity Graph',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 250, // Set a fixed height for the graph
                                child: LineChart(LineChartData(
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: provider.dailyIntensity!
                                          .asMap()
                                          .entries
                                          .map(
                                            (e) => FlSpot(
                                              e.key.toDouble(),
                                              e.value.toDouble(),
                                            ),
                                          )
                                          .toList(),
                                      isCurved: true,
                                      color: Colors.green,
                                      barWidth: 4,
                                      belowBarData: BarAreaData(show: false),
                                    ),
                                  ],
                                  titlesData: const FlTitlesData(show: true),
                                  gridData: const FlGridData(show: true),
                                  borderData: FlBorderData(
                                      show: true,
                                      border: Border.all(color: Colors.green)),
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
