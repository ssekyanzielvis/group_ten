import 'package:flutter/material.dart';
import 'package:food_dash/src/services/geolocation_service.dart';
import 'package:food_dash/src/services/location_service.dart';
import 'package:food_dash/src/widgets/costom_text_field.dart';
import 'package:food_dash/src/widgets/location_card.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class AddLocationScreen extends StatefulWidget {
  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final TextEditingController _addressController = TextEditingController();
  MapController _mapController = MapController();
  LatLng _initialPosition = LatLng(37.7749, -122.4194); // Default to San Francisco
  LatLng? _selectedPosition;
  double? _latitude;
  double? _longitude;
  LatLng? _currentPosition;

  void _fetchCoordinates() async {
    var coordinates = await GeolocationService.getCurrentLocation();
    setState(() {
      _latitude = coordinates.latitude;
      _longitude = coordinates.longitude;
      _initialPosition = LatLng(_latitude!, _longitude!);
      _mapController.move(_initialPosition, 15.0);
      _getAddressFromLatLng(_latitude!, _longitude!);
      _currentPosition = _initialPosition;
    });
  }

  void _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        _addressController.text = address;
      }
    } catch (e) {
      print(e);
    }
  }

  void _saveAddress() async {
    if (_latitude!= null && _longitude!= null) {
      await LocationService.saveAddress(
        _addressController.text,
        _latitude!,
        _longitude!,
      );
      // Show success message or navigate to another screen
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng position) {
    setState(() {
      _selectedPosition = position;
      _latitude = position.latitude;
      _longitude = position.longitude;
      _getAddressFromLatLng(_latitude!, _longitude!);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCoordinates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Delivery Address')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentPosition!= null
                   ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                    : _initialPosition,
                  initialZoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 30.0,
                        height: 30.0,
                        point: _currentPosition!= null
                         ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                          : _initialPosition,
                        child: const Icon(Icons.my_location, color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            CostomTextField(controller: _addressController, labelText: 'Address'),
            SizedBox(height: 10),
            ElevatedButton(onPressed: _fetchCoordinates, child: Text('Fetch Coordinates')),
            ElevatedButton(onPressed: _saveAddress, child: Text('Save Address')),
            if (_latitude!= null && _longitude!= null)
              LocationCard(latitude: _latitude!, longitude: _longitude!)
          ],
        ),
      ),
    );
  }
}