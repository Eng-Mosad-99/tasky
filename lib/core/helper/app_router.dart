import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_tasky/Features/auth/Presentation/views/login_view.dart';
import 'package:todo_tasky/Features/auth/Presentation/views/sign_up_view.dart';
import 'package:todo_tasky/Features/home/presentation/views/home_view.dart';
import '../../Features/auth/Presentation/controller/auth/auth_bloc.dart';
import '../../Features/on_boarding/views/on_boarding_view.dart';
// import 'package:stride/Features/auth/presentation/views/login_view.dart';
// import 'package:stride/Features/dashboard/presentation/views/dashboard_view.dart';
// import 'package:stride/Features/home/presentation/views/about_company_view.dart';
// import 'package:stride/Features/home/presentation/views/closing_deal_releases.dart';
// import 'package:stride/Features/home/presentation/views/new_releases_view.dart';
// import '../../Features/auth/presentation/views/sign_up_view.dart';
// import '../../Features/dashboard/presentation/controller/bloc/dashboard_bloc.dart';
// import '../../Features/dashboard/presentation/controller/bloc/dashboard_event.dart';
// import '../../Features/dashboard/presentation/views/notifications_view.dart';
// import '../../Features/home/presentation/views/call_us_view.dart';
// import '../../Features/home/presentation/views/developer_selection_view.dart';
// import '../../Features/home/presentation/views/edit_profile_view.dart';
// import '../../Features/home/presentation/views/new_releases_details_view.dart';

final GoRouter router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return initAuthBloc(
          child: const OnBoardingView(),
        );
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return initAuthBloc(
          child: const LoginView(),
        );
      },
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return initAuthBloc(
          child: const SignUpView(),
        );
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return initAuthBloc(
          child: const HomeView(),
        );
      },
    ),
  ],
);
