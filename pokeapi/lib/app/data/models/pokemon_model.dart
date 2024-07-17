class PokemonModel {
  final String name;
  final String img;
  final List type;
  // final String url;

  PokemonModel({
    required this.name,
    required this.img,
    this.type = const [],
    // required this.url,
  });

  factory PokemonModel.fromMap(Map<String, dynamic> map) {
    return PokemonModel(
      name: map['name'],
      img: map['img'],
      type: map['type'] ?? [],
      // url: map['url']
    );
  }
}
