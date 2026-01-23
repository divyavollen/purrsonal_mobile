import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workspace/features/home/home_page.dart';
import 'package:workspace/features/pets/widgets/tabs/pet_calendar_tab.dart';
import 'package:workspace/features/pets/widgets/tabs/pet_detail.dart';
import 'package:workspace/features/pets/widgets/tabs/pet_info_tab.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouterConfig {
  GoRouter get router => GoRouter(
    initialLocation: '/',
    navigatorKey: rootNavigatorKey,
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
                    builder: (context, state) => PetCalendarTab(),
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
