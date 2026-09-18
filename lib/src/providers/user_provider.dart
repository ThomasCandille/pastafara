import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

final userProvider = FutureProvider.family<User?, String>((ref, userId) async {
  final userService = ref.watch(userServiceProvider);
  return userService.getUserFromDatabase(userId);
});