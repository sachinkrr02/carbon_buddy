import 'dart:convert';
import 'package:http/http.dart' as http;

class CarbonIntensityService {
  final String baseUrl = 'https://api.carbonintensity.org.uk';

  Future<int?> fetchCurrentIntensity() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/intensity'));
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'][0]['intensity']['actual'];
      }
    } catch (e) {
      print('Error fetching current intensity: $e');
    }
    return null;
  }

  Future<List<int>?> fetchDailyIntensity() async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/intensity/date/$today'));
      print('Daily Intensity Status Code: ${response.statusCode}');
      print('Daily Intensity Response: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Ensure we map each entry to an int, checking that the key exists
        return (data['data'] as List).map<int>((entry) {
          final intensity = entry['intensity']['actual'];
          return intensity is int
              ? intensity
              : 0; // Default to 0 if null or not int
        }).toList();
      }
    } catch (e) {
      print('Error fetching daily intensity: $e');
    }
    return null;
  }
}
