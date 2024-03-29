import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nutriped/app/data/services/auth_service.dart';
import 'package:nutriped/app/ui/pages/add_meal.dart';
import 'package:nutriped/app/ui/pages/home_page.dart';
import 'package:nutriped/app/ui/pages/introduction_page.dart';
import 'package:nutriped/app/ui/pages/link_page.dart';
import 'package:nutriped/app/ui/pages/login_page.dart';
import 'package:nutriped/app/ui/pages/access_page.dart';
import 'package:nutriped/app/ui/pages/patient_page.dart';
import 'package:nutriped/app/ui/pages/register_page.dart';
import 'package:nutriped/app/ui/pages/splash_page.dart';
import 'package:nutriped/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MainApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
      routes: [
        GoRoute(
          path: 'access',
          name: '/access',
          builder: (context, state) => const AccessPage(),
        ),
        GoRoute(
          path: 'add_meal',
          name: '/add_meal',
          builder: (context, state) => const AddMeal(),
        ),
        GoRoute(
          path: 'home',
          name: '/home',
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          path: 'introduction',
          name: '/introduction',
          builder: (context, state) => const IntroductionPage(),
        ),
        GoRoute(
          path: 'login',
          name: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: 'patient',
          name: '/patient',
          builder: (context, state) => const PatientPage(),
        ),
        GoRoute(
          path: 'register',
          name: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: 'link',
          name: '/link',
          builder: (context, state) => const LinkPage(),
        ),
      ],
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
      ),
    );
  }
}
