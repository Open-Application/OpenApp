import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/navigation.dart';
import '../pages/dashboard.dart';
import '../pages/profile.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/dashboard',
    ),
    ShellRoute(
      builder: (context, state, child) => Navigation(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: Dashboard(),
          ),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: Profile(),
          ),
        ),
      ],
    ),
  ],
);