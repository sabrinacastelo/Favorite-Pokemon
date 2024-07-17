import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<String> _favoritePokemon = [];
  List<String> get pokemon => _favoritePokemon;

  void toggleFavorite(String item) {
    final isExist = _favoritePokemon.contains(item);
    if (isExist) {
      _favoritePokemon.remove(item);
    } else {
      _favoritePokemon.add(item);
    }
    notifyListeners();
  }

  bool isExist(String item) {
    final isExist = _favoritePokemon.contains(item);
    return isExist;
  }

  void clearFavorite() {
    _favoritePokemon.clear();
    notifyListeners();
  }
}
