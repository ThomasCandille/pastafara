import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/favorite_provider.dart';
import '../widgets/meal_card.dart';

class FavoriteView extends ConsumerWidget {
  const FavoriteView({super.key});

  Widget _buildHeader(int? total) {
    final totalLabel = total == null
        ? 'Chargement...'
        : 'faoris : $total';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(Icons.favorite, color: Color(0xFFC52820), size: 30),
                    SizedBox(width: 8),
                    Text(
                      'Mes favoris',
                      style: TextStyle(
                        color: Color(0xFF2D1B17),
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE2D8),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                totalLabel,
                style: const TextStyle(
                  color: Color(0xFF6C5247),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'Ton carnet gourmand de recettes et pâtes préférées',
          style: TextStyle(color: Color(0xFF6C5A52), fontSize: 15, height: 1.4),
        ),
      ],
    );
  }

  Widget _buildPage({required int? total, required Widget content}) {
    return ColoredBox(
      color: const Color(0xFFFFFAF8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
            children: [
              _buildHeader(total),
              const SizedBox(height: 20),
              content,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteMeals = ref.watch(favoriteMealsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF8),
      body: favoriteMeals.when(
        data: (meals) {
          if (meals.isEmpty) {
            return _buildPage(
              total: 0,
              content: const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: Text('Aucun plat favori')),
              ),
            );
          }

          return _buildPage(
            total: meals.length,
            content: Column(
              children: [
                for (final meal in meals)
                  buildMealCard(context, ref, meal, favoriteId: meal.id),
              ],
            ),
          );
        },
        loading: () => _buildPage(
          total: null,
          content: const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
        error: (error, _) => _buildPage(
          total: null,
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Center(child: Text('Erreur : $error')),
          ),
        ),
      ),
    );
  }
}
