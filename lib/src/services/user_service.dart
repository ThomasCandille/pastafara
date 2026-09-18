import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore;

  UserService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> addUserToDatabase(String userId, User user) async {
    await _firestore.collection('users').doc(userId).set(user.toJson());
  }
}
