import 'package:flutter/material.dart';
import 'package:football_shop_mobile/menu.dart';

void main() {
  runApp(const FootballShopApp());
}

class FootballShopApp extends StatelessWidget {
  const FootballShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
        ).copyWith(secondary: Colors.tealAccent[400]),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
