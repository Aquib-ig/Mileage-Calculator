import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mileage_calculator/firebase_options.dart';
import 'package:mileage_calculator/providers/auth_provider.dart';
import 'package:mileage_calculator/providers/theme_provider.dart';
import 'package:mileage_calculator/screens/auth/signin_screen.dart';
import 'package:mileage_calculator/screens/auth/signup_screen.dart';
import 'package:mileage_calculator/themes/app_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: "/",
      routes: {"/": (context) => SigninScreen()},
    );
  }
}
