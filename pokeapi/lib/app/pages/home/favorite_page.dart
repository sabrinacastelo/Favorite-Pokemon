import 'package:flutter/material.dart';
import 'package:pokeapi/app/data/http/http_client.dart';
import 'package:pokeapi/app/data/repositories/pokemon_repository.dart';
import 'package:pokeapi/app/pages/home/stores/pokemon_store.dart';
import 'package:pokeapi/provider/favorite_provider.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    final PokemonStore store = PokemonStore(
      repository: PokemonRepository(
        client: HttpClient(),
      ),
    );

    // Filtrar os Pokémon favoritos
    final favoritePokemonList = store.state.value
        .where((pokemon) => provider.isExist(pokemon.name))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(206, 255, 235, 59),
        title: const Text('Favorite Pokémon'),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          store.isloading,
          store.state,
          store.error,
        ]),
        builder: (context, child) {
          if (store.isloading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (store.error.value.isNotEmpty) {
            return Center(
              child: Text(
                store.error.value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (favoritePokemonList.isEmpty) {
            return Center(
              child: Text(
                'Nenhum Pokémon favoritado',
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: 30,
            ),
            padding: const EdgeInsets.all(16),
            itemCount: favoritePokemonList.length,
            itemBuilder: (_, index) {
              final item = favoritePokemonList[index];
              return SizedBox(
                width: 50, // Novo valor de largura menor
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 92, 212),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          item.img,
                          fit: BoxFit.cover,
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          item.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              (item.type).join(', '),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
