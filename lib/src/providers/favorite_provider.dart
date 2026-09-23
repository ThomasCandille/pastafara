import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';

import '../models/meal_model.dart';

final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('Isar doit être initialisé dans main.dart');
});

final favoriteMealsProvider = FutureProvider<List<Meal>>((ref) async {
  final isar = ref.watch(isarProvider);
  return isar.meals.where().findAll();
});
