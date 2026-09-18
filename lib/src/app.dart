import 'package:flutter/material.dart';
import 'package:pastafara/src/router/route_names.dart';
import 'package:pastafara/src/widgets/appbar.dart';
import 'package:pastafara/src/widgets/bottom_navigation_bar.dart';

class MainPage extends StatelessWidget {
  final Widget child;
  final String currentRouteName;

  const MainPage({
    super.key,
    required this.child,
    required this.currentRouteName,
  });

  String get _pageName => switch (currentRouteName) {
    AppRouteNames.explorer => 'Explorer',
    AppRouteNames.chef => 'Chef',
    AppRouteNames.favorite => 'Favoris',
    AppRouteNames.profile => 'Profil',
    _ => 'Home',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Appbar(pageName: _pageName),
      ),
      body: child,
      bottomNavigationBar: AppBottomNavigationBar(
        currentRouteName: currentRouteName,
      ),
    );
  }
}
