
class ServiceProviderModel {
  final String id;
  final String shopName;
  final String phone;
  final List<String> services;
  final double lat;
  final double lng;
  final String address;

  ServiceProviderModel({
    required this.id,
    required this.shopName,
    required this.phone,
    required this.services,
    required this.lat,
    required this.lng,
    required this.address,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'shopName': shopName,
        'phone': phone,
        'services': services,
        'lat': lat,
        'lng': lng,
        'address': address,
        'createdAt': DateTime.now(),
      };

  factory ServiceProviderModel.fromMap(Map<String, dynamic> m) =>
      ServiceProviderModel(
        id: m['id'],
        shopName: m['shopName'],
        phone: m['phone'],
        services: (m['services'] as List).map((e) => e.toString()).toList(),
        lat: (m['lat'] as num).toDouble(),
        lng: (m['lng'] as num).toDouble(),
        address: m['address'] ?? '',
      );
}
