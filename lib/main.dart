// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'db/DatabaseHelper.dart';
import 'providers/auth_provider.dart';
import 'providers/poultry_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/add_bird_screen.dart';
import 'screens/add_feed_screen.dart';
import 'screens/add_labour_screen.dart';
import 'screens/add_income_screen.dart';
import 'screens/add_expense_screen.dart';
import 'screens/list_screen.dart';
import 'screens/reports_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.init();
  await DatabaseHelper.instance.seedDemoDataIfNeeded();
  final prefs = await SharedPreferences.getInstance();
  final storedUserId = prefs.getInt('user_id');
  runApp(MyApp(startUserId: storedUserId));
}

class MyApp extends StatelessWidget {
  final int? startUserId;
  const MyApp({super.key, this.startUserId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(initialUserId: startUserId)),
        ChangeNotifierProvider(create: (_) => PoultryProvider()),
      ],
      child: Consumer<AuthProvider?>(
        builder: (context, auth, _) {
          final initialRoute = (auth?.isLoggedIn ?? false) ? DashboardScreen.routeName : LoginScreen.routeName;
          return MaterialApp(
            title: 'PoultryPro',
            theme: ThemeData(primarySwatch: Colors.green),
            initialRoute: initialRoute,
            routes: {
              LoginScreen.routeName: (_) => const LoginScreen(),
              DashboardScreen.routeName: (_) => const DashboardScreen(),
              AddBirdScreen.routeName: (_) => const AddBirdScreen(),
              AddFeedScreen.routeName: (_) => const AddFeedScreen(),
              AddLabourScreen.routeName: (_) => const AddLabourScreen(),
              AddIncomeScreen.routeName: (_) => const AddIncomeScreen(),
              AddExpenseScreen.routeName: (_) => const AddExpenseScreen(),
              ListScreen.routeName: (_) => const ListScreen(),
              ReportsScreen.routeName: (_) => const ReportsScreen(),
            },
          );
        },
      ),
    );
  }
}
