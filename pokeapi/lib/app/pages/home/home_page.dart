import 'package:flutter/material.dart';
import 'package:pokeapi/app/data/http/http_client.dart';
import 'package:pokeapi/app/data/repositories/pokemon_repository.dart';
import 'package:pokeapi/app/pages/home/favorite_page.dart';
import 'package:pokeapi/app/pages/home/stores/pokemon_store.dart';
import 'package:pokeapi/provider/favorite_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PokemonStore store = PokemonStore(
    repository: PokemonRepository(
      client: HttpClient(),
    ),
  );

  @override
  void initState() {
    super.initState();
    store.getPokemons();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(206, 255, 235, 59),
        title: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: Center(
            child: Image.asset('lib/app/image/pokemon.webp', height: 100),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const FavoritePage()),
                ),
              );
            },
          ),
        ],
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

          if (store.state.value.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum pokemon encontrado',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(
                height: 30,
              ),
              padding: const EdgeInsets.all(16),
              itemCount: store.state.value.length,
              itemBuilder: (_, index) {
                final item = store.state.value[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Container(
                    width: 50, // Novo valor de largura menor
                    height: 250,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 92, 212),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            // Toggle do favorito aqui
                            provider.toggleFavorite(item.name);
                          },
                          icon: provider.isExist(item.name)
                              ? const Icon(Icons.star, color: Colors.amber)
                              : const Icon(Icons.star_border, color: Colors.white),
                        ),
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
                              color: Colors.white,
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
                                  color: Colors.white,
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
          }
        },
      ),
    );
  }
}
