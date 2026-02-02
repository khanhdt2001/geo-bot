import 'package:flutter/material.dart';
import 'map_picker_screen.dart';

class DestinationScreen extends StatefulWidget {
  final double currentLat;
  final double currentLon;
  final Function(double, double) onSave;

  const DestinationScreen({
    super.key,
    required this.currentLat,
    required this.currentLon,
    required this.onSave,
  });

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  late TextEditingController _latController;
  late TextEditingController _lonController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _latController = TextEditingController(
      text: widget.currentLat.toStringAsFixed(6),
    );
    _lonController = TextEditingController(
      text: widget.currentLon.toStringAsFixed(6),
    );
  }

  @override
  void dispose() {
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  void _saveDestination() {
    if (_formKey.currentState!.validate()) {
      final lat = double.parse(_latController.text);
      final lon = double.parse(_lonController.text);
      widget.onSave(lat, lon);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Destination updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _openMapPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPickerScreen(
          initialLat: double.tryParse(_latController.text) ?? widget.currentLat,
          initialLon: double.tryParse(_lonController.text) ?? widget.currentLon,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _latController.text = result['latitude'].toStringAsFixed(6);
        _lonController.text = result['longitude'].toStringAsFixed(6);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Destination'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.location_pin,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              const Text(
                'Set Your Destination',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter coordinates manually or pick from map',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              
              // Latitude field
              TextFormField(
                controller: _latController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Latitude',
                  hintText: 'e.g., 21.0287',
                  prefixIcon: const Icon(Icons.north),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  helperText: 'Range: -90 to 90',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter latitude';
                  }
                  final lat = double.tryParse(value);
                  if (lat == null) {
                    return 'Please enter a valid number';
                  }
                  if (lat < -90 || lat > 90) {
                    return 'Latitude must be between -90 and 90';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Longitude field
              TextFormField(
                controller: _lonController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Longitude',
                  hintText: 'e.g., 105.8542',
                  prefixIcon: const Icon(Icons.east),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  helperText: 'Range: -180 to 180',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter longitude';
                  }
                  final lon = double.tryParse(value);
                  if (lon == null) {
                    return 'Please enter a valid number';
                  }
                  if (lon < -180 || lon > 180) {
                    return 'Longitude must be between -180 and 180';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Pick from map button
              OutlinedButton.icon(
                onPressed: _openMapPicker,
                icon: const Icon(Icons.map),
                label: const Text('Pick from Map'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 30),
              
              // Save button
              ElevatedButton.icon(
                onPressed: _saveDestination,
                icon: const Icon(Icons.save),
                label: const Text('Save Destination'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              
              // Instructions card
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'How to pick destination:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '1. Click "Pick from Map" button\n'
                        '2. Search for a location or tap on map\n'
                        '3. Drag the marker to adjust\n'
                        '4. Click "Confirm Location"\n'
                        '5. Save your destination',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
