import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/meal_model.dart';
import '../services/meal_service.dart';

final mealServiceProvider = Provider<MealService>((ref) {
  return MealService();
});

final randomMealProvider = FutureProvider<Meal>((ref) async {
  final mealService = ref.watch(mealServiceProvider);
  return mealService.fetchRandomMeal();
});

final allMealsProvider = FutureProvider<List<Meal>>((ref) async {
  final mealService = ref.watch(mealServiceProvider);
  return mealService.fetchAllMeals();
});

final suggestedMealsProvider = FutureProvider<List<Meal>>((ref) async {
  final meals = await ref.watch(allMealsProvider.future);
  final shuffledMeals = [...meals]..shuffle();

  return shuffledMeals.take(3).toList();
});
