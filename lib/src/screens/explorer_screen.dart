import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/meal_provider.dart';
import '../widgets/meal_card.dart';

class ExplorerView extends StatelessWidget {
  const ExplorerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          final allMeals = ref.watch(allMealsProvider);

          return allMeals.when(
            data: (meals) => ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return buildMealCard(
                  context,
                  meal.strMeal,
                  meal.strMealThumb,
                  meal.strArea,
                  meal.strCountry,
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Erreur : $error')),
          );
        },
      ),
    );
  }
}
