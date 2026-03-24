
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../core/firestore_service.dart';
import '../core/map_launcher.dart';
import '../core/models.dart';

class CustomerMapScreen extends StatefulWidget {
  const CustomerMapScreen({super.key});
  @override
  State<CustomerMapScreen> createState() => _CustomerMapScreenState();
}

class _CustomerMapScreenState extends State<CustomerMapScreen> {
  final _mapController = MapController();
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final svc = FirestoreService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Services'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (v) => setState(() => _filter = v == 'All' ? '' : v),
            itemBuilder: (ctx) => const [
              PopupMenuItem(value: 'All', child: Text('All')),
              PopupMenuItem(value: 'Electrician', child: Text('Electricians')),
              PopupMenuItem(value: 'Plumber', child: Text('Plumbers')),
              PopupMenuItem(value: 'Carpenter', child: Text('Carpenters')),
            ],
          )
        ],
      ),
      body: StreamBuilder<List<ServiceProviderModel>>(
        stream: svc.watchProviders(service: _filter.isEmpty ? null : _filter),
        builder: (context, snap) {
          final data = snap.data ?? [];
          final markers = data
              .map((sp) => Marker(
                    point: LatLng(sp.lat, sp.lng),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () => _showDetails(sp),
                      child: const Icon(Icons.location_pin, color: Colors.teal, size: 40),
                    ),
                  ))
              .toList();

          final center = data.isNotEmpty
              ? LatLng(data.first.lat, data.first.lng)
              : const LatLng(22.5726, 88.3639);

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: const MapOptions(initialCenter: LatLng(22.5726, 88.3639), initialZoom: 12),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.empoverty',
                  ),
                  MarkerLayer(markers: markers),
                ],
              ),
              Positioned(
                left: 16, right: 16, bottom: 16,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Expanded(child: Text(_filter.isEmpty ? 'All services' : _filter)),
                        const SizedBox(width: 8),
                        const Text('Filter'),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void _showDetails(ServiceProviderModel sp) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sp.shopName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(sp.address.isEmpty
                ? '${sp.lat.toStringAsFixed(5)}, ${sp.lng.toStringAsFixed(5)}'
                : sp.address),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: sp.services.map((e) => Chip(label: Text(e))).toList(),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.close),
                  label: const Text('Close'),
                  onPressed: () => Navigator.pop(ctx),
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.call),
                  label: const Text('Call to inquire'),
                  onPressed: () => MapLauncher.call(sp.phone),
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.map),
                  label: const Text('Open in Maps'),
                  onPressed: () => MapLauncher.openAt(sp.lat, sp.lng, label: sp.shopName),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
