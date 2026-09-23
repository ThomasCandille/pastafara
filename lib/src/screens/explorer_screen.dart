import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/favorite_provider.dart';
import '../providers/meal_provider.dart';
import '../widgets/meal_card.dart';

class ExplorerView extends ConsumerStatefulWidget {
  const ExplorerView({super.key});

  @override
  ConsumerState<ExplorerView> createState() => _ExplorerViewState();
}

class _ExplorerViewState extends ConsumerState<ExplorerView> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final favoriteMeals = ref.watch(favoriteMealsProvider).value ?? [];
    final favoritesByMealId = {
      for (final meal in favoriteMeals) meal.idMeal: meal.id,
    };
    final allMeals = ref.watch(allMealsProvider);

    return Scaffold(
      body: Column(
        children: [
          SearchBar(
            onChanged: (query) {
              setState(() {
                searchText = query.toLowerCase().trim();
              });
            },
          ),
          Expanded(
            child: allMeals.when(
              data: (meals) {
                final filteredMeals = meals.where((meal) {
                  return meal.strMeal.toLowerCase().contains(searchText);
                }).toList();

                return ListView.builder(
                  itemCount: filteredMeals.length,
                  itemBuilder: (context, index) {
                    final meal = filteredMeals[index];
                    return buildMealCard(
                      context,
                      ref,
                      meal,
                      favoriteId: favoritesByMealId[meal.idMeal],
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Erreur : $error')),
            ),
          ),
        ],
      ),
    );
  }
}
