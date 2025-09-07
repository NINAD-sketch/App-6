class Joke {
  final String type;
  final String joke;
  final String setup;
  final String delivery;
  final String category;
  final int id;

  Joke({
    required this.type,
    required this.joke,
    required this.setup,
    required this.delivery,
    required this.category,
    required this.id,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      type: json['type'] ?? 'single',
      joke: json['joke'] ?? '',
      setup: json['setup'] ?? '',
      delivery: json['delivery'] ?? '',
      category: json['category'] ?? 'Miscellaneous',
      id: json['id'] ?? 0,
    );
  }
}
