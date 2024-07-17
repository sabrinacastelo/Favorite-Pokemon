import 'package:flutter/material.dart';
import 'package:pokeapi/app/data/http/exceptions.dart';
import 'package:pokeapi/app/data/models/pokemon_model.dart';
import 'package:pokeapi/app/data/repositories/pokemon_repository.dart';

class PokemonStore {
  final IPokemonRepository repository;

  //loading
  final ValueNotifier<bool> isloading = ValueNotifier<bool>(false);

  //state
  final ValueNotifier<List<PokemonModel>> state =
      ValueNotifier<List<PokemonModel>>([]);

  //error
  final ValueNotifier<String> error = ValueNotifier<String>('');

  PokemonStore({required this.repository});

  Future getPokemons() async {
    isloading.value = true;
    try {
      final result = await repository.getPokemon();
      state.value = result;
    } on NotFoundException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = e.toString();
    }
    isloading.value = false;
  }
}
