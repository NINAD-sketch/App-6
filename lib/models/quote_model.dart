// models/quote_model.dart - UPDATED FOR API NINJAS
class Quote {
  final String content;
  final String author;
  final String category;
  final List<String> tags;
  final int length;

  Quote({
    required this.content,
    required this.author,
    required this.category,
    required this.tags,
    required this.length,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    print('Parsing Quote JSON: $json'); // Debug print

    return Quote(
      content: json['quote'] ??
          'No quote available', // API Ninjas uses 'quote' not 'content'
      author: json['author'] ?? 'Unknown',
      category: json['category'] ?? 'general', // API Ninjas provides category
      tags: [json['category'] ?? 'general'], // Convert category to tags array
      length: (json['quote'] ?? '').length,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quote': content,
      'author': author,
      'category': category,
    };
  }

  @override
  String toString() {
    return 'Quote{content: $content, author: $author, category: $category}';
  }
}
