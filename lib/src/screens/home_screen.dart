import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/user_provider.dart';
import '../router/route_names.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

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

              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Bienvenue, ${user.email}'),
                    const SizedBox(height: 24),
                    const Text('Créer ma recette avec le chef IA'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => context.goNamed(AppRouteNames.chef),
                      child: const Text('Aller voir le chef'),
                    ),
                  ],
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
