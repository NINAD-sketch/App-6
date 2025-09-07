import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey =
      '4c055c20dea04214843ee3e03d514c2d'; // Replace with your NewsAPI key

  Future<List<Article>> getTopHeadlines({String category = 'general'}) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/top-headlines?country=us&category=$category&apiKey=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articles = data['articles'] ?? [];
        return articles.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      // Return demo data if API fails
      return _getDemoArticles(category);
    }
  }

  List<Article> _getDemoArticles(String category) {
    return [
      Article(
        title: 'Flutter 4.0 Released with Revolutionary Features',
        description:
            'Google announces major updates to Flutter framework with improved performance and new widgets for better mobile development.',
        content:
            'The mobile development industry is experiencing rapid growth with new technologies emerging...',
        url: 'https://flutter.dev',
        urlToImage: '',
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        sourceName: 'Dev Weekly',
      ),
      Article(
        title: 'API Integration Best Practices for Mobile Apps',
        description:
            'Learn how to effectively integrate REST APIs in your mobile applications with proper error handling and optimization.',
        content:
            'When building mobile applications, proper API integration is crucial for app performance...',
        url: 'https://docs.flutter.dev',
        urlToImage: '',
        publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
        sourceName: 'Code Academy',
      ),
      Article(
        title: '$category News Update',
        description:
            'Latest updates and developments in the $category sector with comprehensive analysis.',
        content:
            'This is a demo article for the $category category. Replace with actual NewsAPI implementation.',
        url: 'https://pub.dev',
        urlToImage: '',
        publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
        sourceName: 'Category News',
      ),
    ];
  }
}
