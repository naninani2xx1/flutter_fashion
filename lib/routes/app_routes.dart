// ignore_for_file: constant_identifier_names

import 'package:flutter_fashion/app/presentation/personal_information/personal_information.dart';
import 'package:flutter_fashion/app/presentation/setting/setting_page.dart';
import 'package:flutter_fashion/common/components/bottom_navigation_bar.dart';
import 'package:flutter_fashion/app/presentation/notification/notification_page.dart';
import 'package:flutter_fashion/app/presentation/profile/profile_page.dart';
import 'package:flutter_fashion/common/transition/right_to_left.dart';
import 'package:flutter_fashion/core/storage/key.dart';
import 'package:flutter_fashion/routes/export.dart';
import 'package:flutter_fashion/routes/observer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

abstract class Routes {
  Routes._();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static const INTRODUCTION = _Paths.INTRODUCTION;
  static const HOME = _Paths.HOME;
  static const PROFILE = _Paths.PROFILE;
  static const LOGIN = _Paths.LOGIN;
  static const NOTIFICATION = _Paths.NOTIFICATION;

  //page second
  static const SETTING = _Paths.SETTING;
  static const PERSONAL = _Paths.PERSONAL;
  static const REPORT = _Paths.REPORT;
  static const FAVORITE = _Paths.FAVORITE;
  static const ORDER = _Paths.ORDER;
  static const MESSENGER = _Paths.MESSENGER;

  //
  static const CHANGEPASSWORD = _Paths.CHANGEPASSWORD;
}

abstract class _Paths {
  _Paths._();
  static const INTRODUCTION = '/introduction';
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const NOTIFICATION = '/notification';
  static const PROFILE = '/profile';

  //second
  static const SETTING = '/setting';
  static const PERSONAL = '/personal';
  static const REPORT = '/report';
  static const FAVORITE = '/favorite';
  static const MESSENGER = '/messenger';
  static const ORDER = '/order';

  static const CHANGEPASSWORD = 'change_password';
}

abstract class Names {
  Names._();
  // static const INTRODUCTION = '/introduction';
  // static const HOME = '/home';
  // static const LOGIN = '/login';
  // static const NOTIFICATION = '/notification';
  // static const PROFILE = '/profile';

  //page second
  // static const SETTING = '/setting';
  static const PERSONAL = 'personal';
  static const CHANGEPASSWORD = 'changePassword';
  // static const REPORT = '/report';
  // static const FAVORITE = '/favorite';
  // static const MESSENGER = '/messenger';
  // static const ORDER = '/order';
}

class AppRoutes {
  static final router = GoRouter(
    initialLocation: Routes.LOGIN,
    navigatorKey: Routes.navigatorKey,
    debugLogDiagnostics: true,
    observers: [GoRouterObserver()],
    redirect: (context, state) {
      if (state.subloc == Routes.LOGIN) {
        String? isAuthenticated = HydratedBloc.storage.read(KeyStorage.token);

        if (isAuthenticated != null) {
          return Routes.HOME;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        parentNavigatorKey: Routes.navigatorKey,
        path: Routes.INTRODUCTION,
        builder: (context, state) => const IntroductionPage(),
      ),
      GoRoute(
        path: Routes.LOGIN,
        parentNavigatorKey: Routes.navigatorKey,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: Routes.SETTING,
        parentNavigatorKey: Routes.navigatorKey,
        pageBuilder: (context, state) {
          return SlideTransitionPage<SettingPage>(
            key: state.pageKey,
            child: const SettingPage(),
          );
        },
      ),
      GoRoute(
        name: Names.PERSONAL,
        path: Routes.PERSONAL,
        parentNavigatorKey: Routes.navigatorKey,
        pageBuilder: (context, state) {
          return SlideTransitionPage<PersonalInformationPage>(
            key: state.pageKey,
            child: const PersonalInformationPage(),
          );
        },
      ),
      ShellRoute(
        navigatorKey: Routes.shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return Scaffold(
            body: child,
            /* ... */
            bottomNavigationBar: BottomNavigationBarApp(pagePath: state.subloc),
          );
        },
        routes: <RouteBase>[
          GoRoute(
            parentNavigatorKey: Routes.shellNavigatorKey,
            path: Routes.HOME,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: const HomePage(),
              );
            },
          ),
          GoRoute(
            path: Routes.NOTIFICATION,
            parentNavigatorKey: Routes.shellNavigatorKey,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: const NotificationPage(),
              );
            },
          ),
          GoRoute(
            path: Routes.PROFILE,
            parentNavigatorKey: Routes.shellNavigatorKey,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: const ProfilePage(),
              );
            },
          )
        ],
      ),
    ],
    errorBuilder: (context, state) => const ErrorPage(),
  );

  static void go(String path) => Routes.navigatorKey.currentContext!.go(path);
  static void goNamed(String path) =>
      Routes.navigatorKey.currentContext!.goNamed(path);
  static void pop() => Routes.navigatorKey.currentContext!.pop();

  static void push(String path) {
    Routes.navigatorKey.currentContext!.push(path);
  }

  static void goShellKey(String path) {
    Routes.shellNavigatorKey.currentContext!.go(path);
  }

  static void pushShellKey(String path) {
    Routes.shellNavigatorKey.currentContext!.push(path);
  }
}
