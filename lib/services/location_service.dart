import 'package:geolocator/geolocator.dart';

/// Service class to handle location permissions and distance calculations
class LocationService {
  // Default destination coordinates (Hanoi, Vietnam - example)
  double destinationLatitude;
  double destinationLongitude;

  LocationService({
    this.destinationLatitude = 21.0287,
    this.destinationLongitude = 105.8542,
  });

  /// Check and request location permissions
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
          'Location services are disabled. Please enable GPS in settings.');
    }

    // Check current permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission if denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    // Handle permanently denied permissions
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied. Please enable them in app settings.');
    }

    return true;
  }

  /// Get the current device location with high accuracy
  Future<Position> getCurrentLocation() async {
    try {
      // First, handle permissions
      await _handleLocationPermission();

      // Get current position with high accuracy
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      throw Exception('Failed to get location: $e');
    }
  }

  /// Calculate distance between current position and destination
  /// Returns distance in meters
  double calculateDistance(double currentLat, double currentLon) {
    // Use geolocator's distanceBetween method
    // Returns distance in meters
    final double distanceInMeters = Geolocator.distanceBetween(
      currentLat,
      currentLon,
      destinationLatitude,
      destinationLongitude,
    );

    return distanceInMeters;
  }

  /// Update destination coordinates
  void updateDestination(double lat, double lon) {
    destinationLatitude = lat;
    destinationLongitude = lon;
  }
}
