import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_tracker/providers/wish_provider.dart';
import 'package:wish_tracker/screens/wish_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WishProvider()..fetchWishes(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
        home: const WishScreen(),
      ),
    );
  }
}
