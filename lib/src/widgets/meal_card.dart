import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/meal_model.dart';
import '../providers/favorite_provider.dart';

Widget buildMealCard(
  BuildContext context,
  WidgetRef ref,
  Meal meal, {
  int? favoriteId,
}) {
  final isFavorite = favoriteId != null;

  return Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Column(
      children: [
        if (meal.strMealThumb.isNotEmpty)
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.network(
                  meal.strMealThumb,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200.0,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () async {
                    final isar = ref.read(isarProvider);

                    await isar.writeTxn(() async {
                      if (favoriteId != null) {
                        await isar.meals.delete(favoriteId);
                      } else {
                        await isar.meals.put(meal);
                      }
                    });

                    ref.invalidate(favoriteMealsProvider);
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        Row(
          children: [
            Text(meal.strMeal),
            Text(meal.strArea.isNotEmpty ? ' - ${meal.strArea}' : ''),
          ],
        ),
      ],
    ),
  );
}
