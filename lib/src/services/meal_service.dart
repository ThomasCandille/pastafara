import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/meal_model.dart';

class MealService {
  final Dio _dio;

  MealService({Dio? dio}) : _dio = dio ?? Dio();

  Future<Meal> fetchRandomMeal() async {
    final response = await _dio.get<Map<String, Object?>>(
      'https://www.themealdb.com/api/json/v1/1/filter.php?c=Pasta',
    );

    final meals = response.data?['meals'];

    if (meals is! List || meals.isEmpty) {
      throw Exception('Aucune donnée reçue');
    }

    final randomMeal = meals[Random().nextInt(meals.length)];
    debugPrint('Received random meal: $randomMeal');

    return Meal.fromJson(Map<String, dynamic>.from(randomMeal as Map));
  }

  Future<List<Meal>> fetchAllMeals() async {
    final response = await _dio.get<Map<String, Object?>>(
      'https://www.themealdb.com/api/json/v1/1/filter.php?c=Pasta',
    );

    final meals = response.data?['meals'];

    if (meals is! List || meals.isEmpty) {
      throw Exception('Aucune donnée reçue');
    }

    return meals.map((meal) => Meal.fromJson(Map<String, dynamic>.from(meal as Map))).toList();
  }
}
