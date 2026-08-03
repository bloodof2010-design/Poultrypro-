// lib/main.dart
// Entry point for PoultryPro - initializes DB and user session, registers provider and routes.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'db/DatabaseHelper.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/add_poultry_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the local database
  await DatabaseHelper.instance.init();

  // Prepare UserProvider and load session from SharedPreferences
  final userProvider = UserProvider();
  await userProvider.loadFromPrefs();

  // Provide userProvider to the app
  runApp(
    ChangeNotifierProvider<UserProvider>.value(
      value: userProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProv, _) {
        final initialRoute = userProv.isLoggedIn ? DashboardScreen.routeName : LoginScreen.routeName;
        return MaterialApp(
          title: 'PoultryPro',
          theme: ThemeData(
            primarySwatch: Colors.green,
            useMaterial3: false,
          ),
          initialRoute: initialRoute,
          routes: {
            LoginScreen.routeName: (_) => const LoginScreen(),
            DashboardScreen.routeName: (_) => const DashboardScreen(),
            AddPoultryScreen.routeName: (_) => const AddPoultryScreen(),
          },
        );
      },
    );
  }
}
