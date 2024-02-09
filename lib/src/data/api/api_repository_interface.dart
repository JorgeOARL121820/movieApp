import 'package:movie_app/src/data/models/genre/genre_model.dart';
import 'package:movie_app/src/data/models/movie/movie_model.dart';
import 'package:movie_app/src/models/error_model.dart';

abstract class ApiRepositoryInterface {
  Future<(ErrorModel?, List<MovieModel>?)> getMoviesTVList(
      {List<String>? genres,
      int page = 1,
      String? search,
      bool isMovie = true});

  Future<(ErrorModel?, MovieDetailsModel?)> getDetails(int id,
      {bool isMovie = true});

  Future<(ErrorModel?, List<GenreModel>?)> getCats();
  Future<(ErrorModel?, List<GenreModel>?)> getCatsTv();
}
