import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pastafara/src/router/route_names.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final String currentRouteName;

  const AppBottomNavigationBar({super.key, required this.currentRouteName});

  static const routes = [
    AppRouteNames.home,
    AppRouteNames.explorer,
    AppRouteNames.chef,
    AppRouteNames.favorite,
    AppRouteNames.profile,
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = routes.indexOf(currentRouteName);

    return BottomNavigationBar(
      currentIndex: currentIndex < 0 ? 0 : currentIndex,
      onTap: (index) => context.goNamed(routes[index]),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Accueil',
          backgroundColor: Colors.orange
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          label: 'Explorer',
          backgroundColor: Colors.blue
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Chef',
          backgroundColor: Colors.green
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Favoris',
          backgroundColor: Colors.red
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profil',
          backgroundColor: Colors.purple
        ),
      ],
    );
  }
}
