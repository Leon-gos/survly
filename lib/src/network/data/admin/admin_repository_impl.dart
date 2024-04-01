import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survly/src/network/data/admin/admin_repository.dart';
import 'package:survly/src/network/model/admin.dart';

class AdminRepositoryImpl implements AdminRepository {
  final CollectionReference ref =
      FirebaseFirestore.instance.collection("admin");

  @override
  Future<Admin?> getAdminByEmail(String email) async {
    Admin? admin;
    try {
      var snapshot = await ref.where("email", isEqualTo: email).get();
      admin = Admin.fromJson(snapshot.docs[0].data() as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
    return admin;
  }
}
