import 'package:go_router/go_router.dart';
import 'package:pastafara/src/app.dart';
import 'package:pastafara/src/router/route_names.dart';
import 'package:pastafara/src/screens/chef_screen.dart';
import 'package:pastafara/src/screens/explorer_screen.dart';
import 'package:pastafara/src/screens/favorite_screen.dart';
import 'package:pastafara/src/screens/home_screen.dart';
import 'package:pastafara/src/screens/profil_screen.dart';

final appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainPage(
          currentRouteName: state.topRoute?.name ?? AppRouteNames.home,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          name: AppRouteNames.home,
          builder: (context, state) => const HomeView(),
        ),
        GoRoute(
          path: '/explorer',
          name: AppRouteNames.explorer,
          builder: (context, state) => const ExplorerView(),
        ),
        GoRoute(
          path: '/chef',
          name: AppRouteNames.chef,
          builder: (context, state) => const ChefView(),
        ),
        GoRoute(
          path: '/favorite',
          name: AppRouteNames.favorite,
          builder: (context, state) => const FavoriteView(),
        ),
        GoRoute(
          path: '/profile',
          name: AppRouteNames.profile,
          builder: (context, state) => const ProfileView(),
        ),
      ],
    ),
  ],
);
