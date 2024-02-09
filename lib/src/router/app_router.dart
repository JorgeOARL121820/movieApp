import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/src/ui/components/components.dart';
import 'package:movie_app/src/ui/pages/pages.dart';
import 'package:movie_app/src/utils/utils.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: navKey,
  initialLocation: SplashScreen.route,
  redirect: (BuildContext context, GoRouterState state) {
    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: SplashScreen.route,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    ShellRoute(
      navigatorKey: shellKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return ScaffoldBottomNavbar(child: child);
      },
      routes: const <RouteBase>[],
    ),
  ],
);
