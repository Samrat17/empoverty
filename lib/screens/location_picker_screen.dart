
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../core/location_service.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});
  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final _mapController = MapController();
  LatLng? _picked;
  LatLng _center = LatLng(22.5726, 88.3639); // Kolkata default

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final ok = await LocationService().ensurePermission();
    if (!ok) return;
    final pos = await Geolocator.getCurrentPosition();
    setState(() => _center = LatLng(pos.latitude, pos.longitude));
    _mapController.move(_center, 15);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick Location')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 13,
              onTap: (tapPos, latlng) => setState(() => _picked = latlng),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.empoverty',
              ),
              if (_picked != null)
                MarkerLayer(markers: [
                  Marker(
                    point: _picked!,
                    width: 40, height: 40,
                    child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                  )
                ])
            ],
          ),
          Positioned(
            left: 16, right: 16, bottom: 16,
            child: FilledButton(
              onPressed: _picked == null ? null : () => Navigator.pop(context, _picked),
              child: const Text('Use this location'),
            ),
          )
        ],
      ),
    );
  }
}
