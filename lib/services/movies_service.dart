import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieService {
  static const String _baseUrl = 'http://www.omdbapi.com/';
  static const String _apiKey = 'e1f471ff'; // Your OMDB API key

  Future<List<Movie>> getPopularMovies() async {
    try {
      // OMDB API doesn't have a "popular movies" endpoint like TMDB
      // So we'll search for some popular movies by title
      List<String> popularMovieTitles = [
        'Avengers',
        'Spider-Man',
        'Batman',
        'Superman',
        'Iron Man',
        'Thor',
        'Captain America',
        'Wonder Woman',
        'Joker',
        'Black Panther'
      ];

      List<Movie> movies = [];

      for (String title in popularMovieTitles) {
        try {
          final response = await http.get(
            Uri.parse('$_baseUrl?t=$title&apikey=$_apiKey'),
            headers: {'Content-Type': 'application/json'},
          ).timeout(const Duration(seconds: 5));

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            if (data['Response'] == 'True') {
              movies.add(Movie.fromJson(data));
              if (movies.length >= 10) break; // Limit to 10 movies
            }
          }
        } catch (e) {
          print('Error fetching movie $title: $e');
          continue;
        }
      }

      if (movies.isEmpty) {
        return _getDemoMovies();
      }

      return movies;
    } catch (e) {
      print('Error in getPopularMovies: $e');
      return _getDemoMovies();
    }
  }

  Future<Movie?> searchMovie(String title) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?t=$title&apikey=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Response'] == 'True') {
          return Movie.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      print('Error searching movie: $e');
      return null;
    }
  }

  List<Movie> _getDemoMovies() {
    return [
      Movie(
        imdbID: 'tt0111161',
        title: 'The Shawshank Redemption',
        overview:
            'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.',
        posterPath:
            'https://m.media-amazon.com/images/M/MV5BNDE3ODcxYzMtY2YzZC00NmNlLWJiNDMtZDViZWM2MzIxZDYwXkEyXkFqcGdeQXVyNjAwNDUxODI@._V1_SX300.jpg',
        releaseDate: '14 Oct 1994',
        voteAverage: 9.3,
        genre: 'Drama',
        director: 'Frank Darabont',
        actors: 'Tim Robbins, Morgan Freeman, Bob Gunton',
      ),
      Movie(
        imdbID: 'tt0068646',
        title: 'The Godfather',
        overview:
            'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
        posterPath:
            'https://m.media-amazon.com/images/M/MV5BM2MyNjYxNmUtYTAwNi00MTYxLWJmNWYtYzZlODY3ZTk3OTFlXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SX300.jpg',
        releaseDate: '24 Mar 1972',
        voteAverage: 9.2,
        genre: 'Crime, Drama',
        director: 'Francis Ford Coppola',
        actors: 'Marlon Brando, Al Pacino, James Caan',
      ),
      Movie(
        imdbID: 'tt0468569',
        title: 'The Dark Knight',
        overview:
            'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
        posterPath:
            'https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_SX300.jpg',
        releaseDate: '18 Jul 2008',
        voteAverage: 9.0,
        genre: 'Action, Crime, Drama',
        director: 'Christopher Nolan',
        actors: 'Christian Bale, Heath Ledger, Aaron Eckhart',
      ),
    ];
  }
}
