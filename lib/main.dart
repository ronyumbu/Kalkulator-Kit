import 'package:flutter/material.dart';
import 'pages/fuel_calculator_page.dart';
import 'pages/quota_calculator_page.dart';
import 'pages/about_page.dart';
import 'pages/time_calculator_page.dart';
import 'pages/bmi_calculator_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Kit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      initialRoute: '/fuel',
      routes: {
        '/fuel': (context) => const FuelCalculatorPage(),
        '/quota': (context) => const QuotaCalculatorPage(),
        '/time': (context) => const TimeCalculatorPage(),
        '/bmi': (context) => const BMICalculatorPage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}
