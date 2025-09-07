// services/quote_service.dart - FIXED VERSION
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:multi_api_flutter_app/models/qoute_model.dart';

class QuoteService {
  static const String _baseUrl = 'https://api.api-ninjas.com/v1/quotes';
  static const String _apiKey = '3nmtSx2yjEVcjGE1MJs38g==G7zITewK8oruZWx8';

  Future<Quote> getRandomQuote() async {
    try {
      final response = await http.get(
        Uri.parse(
            _baseUrl), // No '/random' needed - API Ninjas returns random by default
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': _apiKey, // Note: Capital X in X-Api-Key
        },
      ).timeout(const Duration(seconds: 10));

      print('Quote API Response Status: ${response.statusCode}');
      print('Quote API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          // API Ninjas returns an array, take the first quote
          return Quote.fromJson(data[0]);
        } else {
          throw Exception('No quotes returned from API');
        }
      } else {
        throw Exception(
            'Failed to load quote: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Quote API Error: $e');
      // Return a fallback quote if API fails
      return Quote(
        content: "The only way to do great work is to love what you do.",
        author: "Steve Jobs",
        tags: ["inspirational", "work"],
        length: 52,
        category: 'inspirational',
      );
    }
  }

  Future<List<Quote>> getQuotesByAuthor(String author) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?author=${Uri.encodeComponent(author)}'),
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': _apiKey,
        },
      ).timeout(const Duration(seconds: 10));

      print('Quotes by Author Response Status: ${response.statusCode}');
      print('Quotes by Author Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Quote.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load quotes by author: ${response.statusCode}');
      }
    } catch (e) {
      print('Quotes by Author Error: $e');
      return []; // Return empty list on error
    }
  }

  Future<List<Quote>> getQuotesByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?category=${Uri.encodeComponent(category)}'),
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': _apiKey,
        },
      ).timeout(const Duration(seconds: 10));

      print('Quotes by Category Response Status: ${response.statusCode}');
      print('Quotes by Category Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Quote.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load quotes by category: ${response.statusCode}');
      }
    } catch (e) {
      print('Quotes by Category Error: $e');
      return []; // Return empty list on error
    }
  }

  // Test method to verify API connectivity
  Future<bool> testApiConnection() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': _apiKey,
        },
      ).timeout(const Duration(seconds: 5));

      print('API Test Response Status: ${response.statusCode}');
      print('API Test Response Headers: ${response.headers}');
      print('API Test Response Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('API Test Error: $e');
      return false;
    }
  }
}
