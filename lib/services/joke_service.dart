import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/joke_model.dart';

class JokeService {
  static const String _baseUrl = 'https://v2.jokeapi.dev';

  Future<Joke> getRandomJoke() async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/joke/Programming,Miscellaneous,Pun?blacklistFlags=nsfw,religious,political,racist,sexist,explicit&type=single,twopart'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Joke.fromJson(data);
    } else {
      throw Exception('Failed to load joke: ${response.statusCode}');
    }
  }

  Future<Joke> getJokeByCategory(String category) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/joke/$category?blacklistFlags=nsfw,religious,political,racist,sexist,explicit'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Joke.fromJson(data);
    } else {
      throw Exception('Failed to load joke: ${response.statusCode}');
    }
  }

  Future<List<String>> getAvailableCategories() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/categories'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data['categories'] ?? []);
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }
}
