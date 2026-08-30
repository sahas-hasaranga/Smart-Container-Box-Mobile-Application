import 'package:firebase_database/firebase_database.dart';

class IotDatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Stream for live metrics (temperature, humidity, etc.)
  Stream<Map<String, dynamic>> getLiveMetricsStream() {
    return _dbRef.child('container_data/metrics').onValue.map((event) {
      if (event.snapshot.value != null) {
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      }
      return {};
    });
  }

  // Stream for GPS coordinates
  Stream<Map<String, dynamic>> getGpsStream() {
    return _dbRef.child('container_data/gps').onValue.map((event) {
      if (event.snapshot.value != null) {
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      }
      return {};
    });
  }

  // Stream for Camera URL or status
  Stream<Map<String, dynamic>> getCameraInfoStream() {
    return _dbRef.child('container_data/camera').onValue.map((event) {
      if (event.snapshot.value != null) {
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      }
      return {};
    });
  }
}
