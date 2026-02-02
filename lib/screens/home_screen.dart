import 'package:flutter/material.dart';
import '../services/location_service.dart';
import 'destination_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationService _locationService = LocationService();
  
  String _statusMessage = 'Press the button to get your location';
  double? _currentLatitude;
  double? _currentLongitude;
  double? _distanceInKm;
  bool _isLoading = false;

  /// Get current location and calculate distance
  Future<void> _getLocationAndDistance() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Getting your location...';
    });

    try {
      final position = await _locationService.getCurrentLocation();
      final distance = _locationService.calculateDistance(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _currentLatitude = position.latitude;
        _currentLongitude = position.longitude;
        _distanceInKm = distance / 1000; // Convert meters to kilometers
        _statusMessage = 'Location retrieved successfully!';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  void _openDestinationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DestinationScreen(
          currentLat: _locationService.destinationLatitude,
          currentLon: _locationService.destinationLongitude,
          onSave: (lat, lon) {
            setState(() {
              _locationService.updateDestination(lat, lon);
              _statusMessage = 'Destination updated! Get location to calculate new distance.';
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geo Bot'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Update Destination',
            onPressed: _openDestinationScreen,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status message
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Current coordinates
            if (_currentLatitude != null && _currentLongitude != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Your Current Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Latitude: ${_currentLatitude!.toStringAsFixed(6)}'),
                      Text('Longitude: ${_currentLongitude!.toStringAsFixed(6)}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Distance to destination
            if (_distanceInKm != null) ...[
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Distance to Destination',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_distanceInKm!.toStringAsFixed(2)} km',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Destination info card
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Current Destination',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Lat: ${_locationService.destinationLatitude.toStringAsFixed(6)}'),
                    Text('Lon: ${_locationService.destinationLongitude.toStringAsFixed(6)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Get location button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _getLocationAndDistance,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.location_on),
              label: Text(_isLoading ? 'Loading...' : 'Get Location'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),

            // Update destination button
            OutlinedButton.icon(
              onPressed: _openDestinationScreen,
              icon: const Icon(Icons.edit_location),
              label: const Text('Update Destination'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
