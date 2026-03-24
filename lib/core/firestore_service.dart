import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart';

class FirestoreService {
  final _col = FirebaseFirestore.instance.collection('providers');

  Future<void> addProvider(ServiceProviderModel sp) async {
    await _col.doc(sp.id).set(sp.toMap());
  }

  Stream<List<ServiceProviderModel>> watchProviders({String? service}) {
    Query q = _col;
    if (service != null && service.isNotEmpty) {
      q = q.where('services', arrayContains: service);
    }
    return q.snapshots().map((s) =>
        s.docs.map((d) => ServiceProviderModel.fromMap(d.data() as Map<String, dynamic>)).toList());
  }
}