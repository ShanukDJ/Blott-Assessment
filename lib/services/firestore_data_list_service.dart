// lib/services/firestore_service.dart
import 'package:blott_mobile_assessment/models/list_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch all data from the Firestore collection
  Future<List<DataModel>> fetchDataList() async {
    try {
      final QuerySnapshot snapshot = await _db.collection('list').get();

      // Convert the query snapshot into a list of DocumentModel
      return snapshot.docs.map((doc) {
        return DataModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch documents: $e');
    }
  }

}
