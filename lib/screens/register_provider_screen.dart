
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
import '../core/firestore_service.dart';
import '../core/location_service.dart';
import '../core/models.dart';
import 'location_picker_screen.dart';

class RegisterProviderScreen extends StatefulWidget {
  const RegisterProviderScreen({super.key});
  @override
  State<RegisterProviderScreen> createState() => _RegisterProviderScreenState();
}

class _RegisterProviderScreenState extends State<RegisterProviderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _services = <String, bool>{
    'Electrician': false,
    'Plumber': false,
    'Carpenter': false,
  };

  LatLng? _picked;
  String _address = '';
  bool _saving = false;

  Future<void> _pickLocation() async {
    final result = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
    );
    if (result != null) {
      setState(() => _picked = result);
      final addr = await LocationService().reverseGeocode(result.latitude, result.longitude);
      setState(() => _address = addr);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _picked == null) return;
    setState(() => _saving = true);
    final svc = FirestoreService();
    final id = const Uuid().v4();
    final sp = ServiceProviderModel(
      id: id,
      shopName: _shopCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      services: _services.entries.where((e) => e.value).map((e) => e.key).toList(),
      lat: _picked!.latitude,
      lng: _picked!.longitude,
      address: _address,
    );
    await svc.addProvider(sp);
    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _picked != null;
    return Scaffold(
      appBar: AppBar(title: const Text('Register Service Provider')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _shopCtrl,
              decoration: const InputDecoration(labelText: 'Name of the shop'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            const Text('Tick all services you would offer', style: TextStyle(fontWeight: FontWeight.bold)),
            ..._services.keys.map((k) => CheckboxListTile(
                  value: _services[k],
                  onChanged: (v) => setState(() => _services[k] = v ?? false),
                  title: Text(k),
                )),
            TextFormField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone number'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    label: Text(_picked == null ? 'Pick Location' : 'Change Location'),
                    onPressed: _pickLocation,
                  ),
                ),
              ],
            ),
            if (_picked != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _address.isEmpty
                      ? 'Picked: ${_picked!.latitude.toStringAsFixed(5)}, ${_picked!.longitude.toStringAsFixed(5)}'
                      : _address,
                  style: const TextStyle(color: Colors.teal),
                ),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: canSave && !_saving ? _save : null,
              child: _saving
                  ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
