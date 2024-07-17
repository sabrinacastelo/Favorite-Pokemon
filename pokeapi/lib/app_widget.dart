import 'package:flutter/material.dart';
import 'package:pokeapi/provider/favorite_provider.dart';
import 'package:provider/provider.dart';
import 'app/pages/home/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoriteProvider(),
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
