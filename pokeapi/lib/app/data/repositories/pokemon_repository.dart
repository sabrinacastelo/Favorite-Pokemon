import 'dart:convert';

import 'package:pokeapi/app/data/http/exceptions.dart';
import 'package:pokeapi/app/data/http/http_client.dart';
import 'package:pokeapi/app/data/models/pokemon_model.dart';

abstract class IPokemonRepository {
  Future<List<PokemonModel>> getPokemon();
}

class PokemonRepository implements IPokemonRepository {
  final IHttpClient client;

  PokemonRepository({required this.client});

  @override
  Future<List<PokemonModel>> getPokemon() async {
    // int limit = 20; // Define o limite de resultados desejado
    // int offset = 0; // Define o offset inicial

    final response = await client.get(
      url: 'https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json',
      // url: 'https://pokeapi.co/api/v2/pokemon?limit=$limit&offset=$offset',
    );

    if (response.statusCode == 200) {
      final List<PokemonModel> pokemons = [];

      final body = jsonDecode(response.body);

      body['pokemon'].forEach((item) {
        final PokemonModel pokemon = PokemonModel.fromMap(item);
        pokemons.add(pokemon);
      });

      return pokemons;
    } else if (response.statusCode == 404) {
      throw NotFoundException('URL não válida');
    } else {
      throw Exception('Não foi possível carregar os dados');
    }
  }
}
