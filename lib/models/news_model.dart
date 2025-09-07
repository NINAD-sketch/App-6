class Article {
  final String title;
  final String description;
  final String content;
  final String url;
  final String urlToImage;
  final DateTime publishedAt;
  final String sourceName;

  Article({
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.sourceName,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : DateTime.now(),
      sourceName: json['source']?['name'] ?? 'Unknown Source',
    );
  }
}
