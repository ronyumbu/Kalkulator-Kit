import 'package:flutter/material.dart';
import 'pages/area_pages/area_calculator_page.dart';
import 'pages/area_pages/area_square_page.dart';
import 'pages/area_pages/area_rectangle_page.dart';
import 'pages/area_pages/area_triangle_page.dart';
import 'pages/area_pages/area_parallelogram_page.dart';
import 'pages/area_pages/area_trapezoid_page.dart';
import 'pages/area_pages/area_rhombus_page.dart';
import 'pages/area_pages/area_circle_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'pages/splash_screen.dart';
import 'pages/basic_calculator_page.dart';
import 'pages/fuel_calculator_page.dart';
import 'pages/quota_calculator_page.dart';
import 'pages/about_page.dart';
import 'pages/time_calculator_page.dart';
import 'pages/bmi_calculator_page.dart';
import 'pages/date_calculator_page.dart';
import 'pages/age_calculator_page.dart';
import 'pages/settings_page.dart';
import 'services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize settings service
  final settingsService = SettingsService();
  await settingsService.loadSettings();

  runApp(MyApp(settingsService: settingsService));
}

class MyApp extends StatefulWidget {
  final SettingsService settingsService;

  const MyApp({super.key, required this.settingsService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.settingsService,
      child: Consumer<SettingsService>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'Kalkulator Kit',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('id', 'ID'), // Indonesian
              Locale('en', 'US'), // English
            ],
            locale: const Locale('id', 'ID'),
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
              fontFamily: 'Roboto',
              scaffoldBackgroundColor: Colors.grey[200],
              cardTheme: CardThemeData(
                color: Colors.white,
                elevation: 2,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              fontFamily: 'Roboto',
              scaffoldBackgroundColor: const Color(0xFF121212),
              cardTheme: const CardThemeData(
                color: Color(0xFF1E1E1E),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: const Color(0xFF2C2C2C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF404040)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF404040)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                labelStyle: const TextStyle(color: Color(0xFFE0E0E0)),
              ),
              textTheme: const TextTheme(
                headlineLarge: TextStyle(color: Colors.white),
                headlineMedium: TextStyle(color: Colors.white),
                headlineSmall: TextStyle(color: Colors.white),
                titleLarge: TextStyle(color: Colors.white),
                titleMedium: TextStyle(color: Colors.white),
                titleSmall: TextStyle(color: Colors.white),
                bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
                bodyMedium: TextStyle(color: Color(0xFFE0E0E0)),
                bodySmall: TextStyle(color: Color(0xFFBDBDBD)),
                labelLarge: TextStyle(color: Colors.white),
                labelMedium: TextStyle(color: Color(0xFFE0E0E0)),
                labelSmall: TextStyle(color: Color(0xFFBDBDBD)),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF1E1E1E),
                foregroundColor: Colors.white,
                elevation: 2,
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(color: Colors.white),
              ),
            ),
            themeMode: settings.getThemeMode(),
            home: const SplashScreen(),
            routes: {
              '/calculator': (context) => const BasicCalculatorPage(),
              '/fuel': (context) => const FuelCalculatorPage(),
              '/quota': (context) => const QuotaCalculatorPage(),
              '/time': (context) => const TimeCalculatorPage(),
              '/bmi': (context) => const BMICalculatorPage(),
              '/date': (context) => const DateCalculatorPage(),
              '/age': (context) => const AgeCalculatorPage(),
              '/settings': (context) => const SettingsPage(),
              '/about': (context) => const AboutPage(),
              '/area_calculator': (context) => const AreaCalculatorPage(),
              '/area_square': (context) => const AreaSquarePage(),
              '/area_rectangle': (context) => const AreaRectanglePage(),
              '/area_triangle': (context) => const AreaTrianglePage(),
              '/area_parallelogram': (context) => const AreaParallelogramPage(),
              '/area_trapezoid': (context) => const AreaTrapezoidPage(),
              '/area_rhombus': (context) => const AreaRhombusPage(),
              '/area_circle': (context) => const AreaCirclePage(),
            },
          );
        },
      ),
    );
  }
}
