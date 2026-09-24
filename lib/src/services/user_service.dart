import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore;

  UserService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> addUserToDatabase(String userId, User user) async {
    await _firestore.collection('users').doc(userId).set(user.toJson());
  }

  Future<User?> getUserFromDatabase(String userId) async {
    final userdata = await _firestore.collection('users').doc(userId).get();
    if (userdata.exists) {
      return User.fromJson(userdata.data()!);
    }
    return null;
  }

  Future<void> addFavoriteMeal(String userId, String mealName) async {
    await _firestore.collection('users').doc(userId).set({
      'favoriteMeals': FieldValue.arrayUnion([mealName]),
    }, SetOptions(merge: true));
  }

  Future<void> removeFavoriteMeal(String userId, String mealName) async {
    await _firestore.collection('users').doc(userId).set({
      'favoriteMeals': FieldValue.arrayRemove([mealName]),
    }, SetOptions(merge: true));
  }
}
