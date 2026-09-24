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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.travel_explore, color: Color(0xFFC52820), size: 30),
              SizedBox(width: 8),
              Text(
                'Explorer',
                style: TextStyle(
                  color: Color(0xFF2D1B17),
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Trouve l’inspiration ou découvre les secrets des pâtes artisanales.',
            style: TextStyle(
              color: Color(0xFF6C5A52),
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          SearchBar(
            hintText: 'Rechercher une recette, une forme...',
            leading: const Icon(Icons.search, color: Color(0xFF51433D)),
            backgroundColor: const WidgetStatePropertyAll(Color(0xFFFFEEE8)),
            elevation: const WidgetStatePropertyAll(0),
            shape: const WidgetStatePropertyAll(StadiumBorder()),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (query) {
              setState(() {
                searchText = query.toLowerCase().trim();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE2D8),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Row(
        children: [
          Icon(Icons.favorite_border, color: Color(0xFFC52820)),
          SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  color: Color(0xFF6C5A52),
                  fontSize: 14,
                  height: 1.35,
                ),
                children: [
                  TextSpan(
                    text: 'Toutes nos pâtes sont sélectionnées avec amour. ',
                  ),
                  TextSpan(
                    text: 'Les pâtes ne mentent jamais !',
                    style: TextStyle(
                      color: Color(0xFF3B2A24),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMeals = ref.watch(favoriteMealsProvider).value ?? [];
    final favoritesByMealId = {
      for (final meal in favoriteMeals) meal.idMeal: meal.id,
    };
    final allMeals = ref.watch(allMealsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF8),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: allMeals.when(
            data: (meals) {
              final filteredMeals = meals.where((meal) {
                return meal.strMeal.toLowerCase().contains(searchText);
              }).toList();

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader()),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final meal = filteredMeals[index];
                      return buildMealCard(
                        context,
                        ref,
                        meal,
                        favoriteId: favoritesByMealId[meal.idMeal],
                      );
                    }, childCount: filteredMeals.length),
                  ),
                  SliverToBoxAdapter(child: _buildFooter()),
                ],
              );
            },
            loading: () => CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
            error: (error, _) => CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('Erreur : $error')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
