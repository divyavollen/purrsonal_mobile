import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workspace/app/home_page.dart';
import 'package:workspace/pets/pet_detail.dart';
import 'package:workspace/pets/pet_info_tab.dart';

class AppRouterConfig {
  final _rootNavigatorKey = GlobalKey<NavigatorState>();

  GoRouter get router => GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => HomePage(),
      ),

      GoRoute(
        path: '/pet/:petId',
        redirect: (context, state) {
          if (state.uri.pathSegments.length == 2) {
            return '/pet/${state.pathParameters['petId']}/info';
          }
          return null;
        },
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return PetDetails(
                petId: state.pathParameters['petId']!,
                navigationShell: navigationShell,
              );
            },
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    name: 'pet-info',
                    path: 'info',
                    builder: (context, state) => PetInfoTab(
                      petId: state.pathParameters['petId']!,
                    ),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    name: 'pet-cal',
                    path: 'calendar',
                    builder: (context, state) => const Text('Calendar'),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    name: 'pet-a',
                    path: 'settings',
                    builder: (context, state) => const Text('Whatever'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
