import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/network/data/location_log/location_log_repository.dart';
import 'package:survly/src/network/model/location_log/location_log.dart';

class LocationLogRepositoryImpl implements LocationLogRepository {
  final ref = FirebaseFirestore.instance.collection(
    DsLocationLog.collectionName,
  );

  @override
  Future<void> addLocationLog(LocationLog locationLog) async {
    await ref.add(locationLog.toMap());
  }
}
