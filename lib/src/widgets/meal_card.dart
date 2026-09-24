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
  final details = {
    meal.strArea,
    meal.strCountry,
  }.where((value) => value.isNotEmpty).join(' • ');

  Future<void> toggleFavorite() async {
    final isar = ref.read(isarProvider);

    await isar.writeTxn(() async {
      if (favoriteId != null) {
        await isar.meals.delete(favoriteId);
      } else {
        await isar.meals.put(meal);
      }
    });

    ref.invalidate(favoriteMealsProvider);
  }

  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    elevation: 0,
    color: const Color(0xFFFFF1ED),
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (meal.strMealThumb.isNotEmpty)
          Stack(
            children: [
              Image.network(
                meal.strMealThumb,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 210,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: toggleFavorite,
                    tooltip: isFavorite
                        ? 'Retirer des favoris'
                        : 'Ajouter aux favoris',
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: const Color(0xFFC52820),
                    ),
                  ),
                ),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (meal.strMeal.isNotEmpty)
                Text(
                  meal.strMeal,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF2D1B17),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              if (details.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  details,
                  style: const TextStyle(
                    color: Color(0xFF6C5A52),
                    fontSize: 15,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}
