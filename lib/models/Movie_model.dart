class Movie {
  final String imdbID;
  final String title;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final double voteAverage;
  final String genre;
  final String director;
  final String actors;

  Movie({
    required this.imdbID,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.genre,
    required this.director,
    required this.actors,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // Convert OMDB rating to 0-10 scale
    double rating = 0.0;
    String imdbRating = json['imdbRating'] ?? 'N/A';
    if (imdbRating != 'N/A' && imdbRating.isNotEmpty) {
      try {
        rating = double.parse(imdbRating);
      } catch (e) {
        rating = 0.0;
      }
    }

    return Movie(
      imdbID: json['imdbID'] ?? '',
      title: json['Title'] ?? 'Unknown Title',
      overview: json['Plot'] ?? 'No description available',
      posterPath: json['Poster'] ?? '',
      releaseDate: json['Released'] ?? 'Unknown',
      voteAverage: rating,
      genre: json['Genre'] ?? 'Unknown',
      director: json['Director'] ?? 'Unknown',
      actors: json['Actors'] ?? 'Unknown',
    );
  }

  // For backward compatibility, we'll keep the id getter
  String get id => imdbID;
}
