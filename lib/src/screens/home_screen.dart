import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/favorite_provider.dart';
import '../providers/meal_provider.dart';
import '../providers/user_provider.dart';
import '../router/route_names.dart';
import '../widgets/meal_card.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  String _displayName(User firebaseUser, String email) {
    final name = firebaseUser.displayName?.trim();
    if (name != null && name.isNotEmpty) return name;

    final emailName = email.split('@').first.trim();
    if (emailName.isEmpty) return 'Utilisateur';

    return '${emailName[0].toUpperCase()}${emailName.substring(1)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final firebaseUser = snapshot.data ?? FirebaseAuth.instance.currentUser;

        if (firebaseUser == null) {
          return const Scaffold(
            body: Center(child: Text('Veuillez vous connecter')),
          );
        }

        final userInfo = ref.watch(userProvider(firebaseUser.uid));

        return Scaffold(
          body: userInfo.when(
            data: (user) {
              if (user == null) {
                return const Center(child: Text('Utilisateur non trouvé'));
              }

              final userName = _displayName(firebaseUser, user.email);
              final suggestedMeals = ref.watch(suggestedMealsProvider);
              final favoriteMeals =
                  ref.watch(favoriteMealsProvider).value ?? [];
              final favoritesByMealId = {
                for (final meal in favoriteMeals) meal.idMeal: meal.id,
              };

              return ColoredBox(
                color: const Color(0xFFFFFAF8),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                      children: [
                        Text(
                          'Bonjour, $userName 👋',
                          style: const TextStyle(
                            color: Color(0xFF65534B),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Text(
                                'Qu’est-ce qu’on\ncuisine aujourd’hui ?',
                                style: TextStyle(
                                  color: Color(0xFF2D1B17),
                                  fontSize: 32,
                                  height: 1.2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 54,
                              height: 54,
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF5C451),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/icons/restaurant_menu.png',
                                color: const Color(0xFF8D2C21),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE5B4),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  '✨ NOUVEAU & MAGIQUE',
                                  style: TextStyle(
                                    color: Color(0xFF87660B),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'Créer ma recette avec le Chef IA',
                                style: TextStyle(
                                  color: Color(0xFF2D1B17),
                                  fontSize: 27,
                                  height: 1.15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Renseigne ce qu’il y a dans ton frigo, le Chef s’occupe de créer ton plat de pâtes sur-mesure !',
                                style: TextStyle(
                                  color: Color(0xFF6C5247),
                                  fontSize: 16,
                                  height: 1.55,
                                ),
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () =>
                                      context.goNamed(AppRouteNames.chef),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFC52820),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: const FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Créer ma recette avec le Chef IA',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Icon(Icons.arrow_forward, size: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Plats à essayer',
                          style: TextStyle(
                            color: Color(0xFF2D1B17),
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        suggestedMeals.when(
                          data: (meals) => Column(
                            children: [
                              for (final meal in meals)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: buildMealCard(
                                    context,
                                    ref,
                                    meal,
                                    favoriteId: favoritesByMealId[meal.idMeal],
                                  ),
                                ),
                            ],
                          ),
                          loading: () => const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (error, _) => const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Impossible de charger les plats pour le moment.',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Erreur : $error')),
          ),
        );
      },
    );
  }
}
