import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter_ddd/presentation/sign_in/sign_in_page.dart';
import 'package:flutter_ddd/presentation/splash/splash_page.dart';

@MaterialAutoRouter(
  generateNavigationHelperExtension: true,
  routes: <AutoRoute>[
    MaterialRoute(page: SignInPage, initial: true),
    MaterialRoute(page: SplashPage),
  ],
)
class $Router {
}
