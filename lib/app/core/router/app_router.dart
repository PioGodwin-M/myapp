import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/app/data/datasources/remote/auth_service.dart';
import 'package:myapp/app/data/repositories/user_repository.dart';
import 'package:myapp/app/presentation/pages/auth/login_page.dart';
import 'package:myapp/app/presentation/pages/consumer/consumer_dashboard.dart';
import 'package:myapp/app/presentation/pages/farmer/farmer_dashboard.dart';
import 'package:myapp/app/presentation/pages/shared/home_page.dart';
import 'package:myapp/app/presentation/pages/trader/trader_dashboard.dart';

import '../enums/role.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
        redirect: (BuildContext context, GoRouterState state) async {
          final authService = AuthService();
          final user = authService.currentUser;

          if (user == null) {
            return '/login';
          }

          final userRepository = UserRepository();
          final appUser = await userRepository.getUser(user.uid);

          if (appUser == null) {
            return '/login';
          }

          switch (appUser.role) {
            case Role.farmer:
              return '/farmer';
            case Role.trader:
              return '/trader';
            case Role.consumer:
              return '/consumer';
            default:
              return '/login';
          }
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/farmer',
        builder: (BuildContext context, GoRouterState state) {
          return const FarmerDashboard();
        },
      ),
      GoRoute(
        path: '/trader',
        builder: (BuildContext context, GoRouterState state) {
          return const TraderDashboard();
        },
      ),
      GoRoute(
        path: '/consumer',
        builder: (BuildContext context, GoRouterState state) {
          return const ConsumerDashboard();
        },
      ),
    ],
  );
}
