import '../../views/login_screen.dart';
import '../../views/register_screen.dart';
import '../../views/splash_screen.dart';
import '../../views/direct_tanima.dart';
import '../../views/home.dart';
import '../../views/user_page.dart';

class RouteNames {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const directTanima = '/direct_tanima';
  static const user = '/user';
  static const register = '/register';
}

class AppRoutes {
  static final routes = {
    RouteNames.splash: (context) => const SplashScreen(),
    RouteNames.login: (context) => const LoginScreen(),
    RouteNames.home: (context) => const HomePage(),
    RouteNames.directTanima: (context) => DirectTanimaPage(),
    RouteNames.user: (context) => const UserPage(),
    RouteNames.register: (context) => const RegisterScreen(),
  };
}
