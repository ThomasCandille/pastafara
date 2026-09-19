import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/user_provider.dart';
import '../providers/meal_provider.dart';
import '../widgets/meal_card.dart';

class ExplorerView extends ConsumerWidget {
  const ExplorerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Utilisateur non connecté')),
      );
    }

    final userFavorite = ref.watch(favoriteMealsProvider(userId));

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
                  ref,
                  meal.strMeal,
                  meal.strMealThumb,
                  meal.strArea,
                  meal.strCountry,
                  isFavorite:
                      userFavorite.value?.contains(meal.strMeal) ?? false,
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
