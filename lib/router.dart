import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'pages/home_page.dart';
import 'pages/twitter/login.dart';
import '../globals.dart';
import '../state/local.dart';

final GoRouter router = GoRouter(
  initialLocation: '/signin',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (_, __) => '/main',
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return HomePage();
      },
    ),
    GoRoute(
      path: '/signin',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
  ],
  redirect: _guard
);

String? _guard(BuildContext context, GoRouterState state) {
  final signedIn = getIt<LocalState>().hasToken();
  final signingIn = state.subloc == '/signin';

  if (!signedIn && !signingIn) {
    return '/signin';
  }
  else if (signedIn && signingIn) {
    return '/main';
  }

  return null;
}
