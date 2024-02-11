import 'dart:convert';

import 'package:movie_app/src/data/api/enum/api_movie_type.dart';
import 'package:movie_app/src/data/models/account/account_model.dart';
import 'package:movie_app/src/data/models/genre/genre_model.dart';
import 'package:movie_app/src/data/models/movie/movie_model.dart';
import 'package:movie_app/src/utils/utils.dart';

enum DataStorageKey {
  details("ST_Details"),
  moviesPerPage("ST_MOVIES_PP"),
  popular("ST_POPULAR"),
  upcoming("ST_UPCOMING"),
  topRated("ST_TOP_RATED"),
  nowPlaying("ST_NOW_PLAYING"),
  account("ST_ACCOUNT"),
  genreMovie("ST_GENRE_MOVIE");

  const DataStorageKey(this.name);
  final String name;
}

class Storage {
  void saveAccount(AccountModel account) {
    prefs.setString(DataStorageKey.account.name, account.toString());
  }

  AccountModel? getAccount() {
    return AccountModel.fromMap(
        json.decode(prefs.getString(DataStorageKey.account.name) ?? '{}'));
  }

  void saveGenre({List<GenreModel>? movies}) {
    prefs.setString(DataStorageKey.genreMovie.name, json.encode(movies));
  }

  List<GenreModel> getGenreModel() {
    return ((json.decode(
                prefs.getString(DataStorageKey.genreMovie.name) ?? '[]'))
            as List<dynamic>)
        .map((dynamic e) => GenreModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  void saveMoviesPerPage(int page, List<MovieModel> moviesToSaved) {
    final Map<String, dynamic> movies = getMoviesPerPage(allPages: true);

    movies["$page"] = moviesToSaved;

    prefs.setString(DataStorageKey.moviesPerPage.name, json.encode(movies));
  }

  dynamic getMoviesPerPage({bool allPages = false, int? page}) {
    if (allPages) {
      return json
          .decode(prefs.getString(DataStorageKey.moviesPerPage.name) ?? '{}');
    } else if (page != null) {
      final Map<String, dynamic> moviesPerPage = json
          .decode(prefs.getString(DataStorageKey.moviesPerPage.name) ?? '{}');

      return (moviesPerPage["$page"] as List<dynamic>?)
          ?.map((dynamic e) => MovieModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } else {
      return null;
    }
  }

  void saveMovies(List<MovieModel> movies, MovieCatType type) {
    prefs.setString(
        type == MovieCatType.nowPlaying
            ? DataStorageKey.nowPlaying.name
            : type == MovieCatType.popular
                ? DataStorageKey.popular.name
                : type == MovieCatType.topRated
                    ? DataStorageKey.topRated.name
                    : DataStorageKey.upcoming.name,
        json.encode(movies));
  }

  List<MovieModel> getMovies(MovieCatType type) {
    final List<dynamic> movies =
        json.decode(prefs.getString(type == MovieCatType.nowPlaying
                ? DataStorageKey.nowPlaying.name
                : type == MovieCatType.popular
                    ? DataStorageKey.popular.name
                    : type == MovieCatType.topRated
                        ? DataStorageKey.topRated.name
                        : DataStorageKey.upcoming.name) ??
            '[]');

    return movies
        .map((dynamic e) => MovieModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveDetails(int movieId, MovieDetailsModel movie) async {
    final Map<String, dynamic> movies = getDetailsMovie(all: true);

    movies["$movieId"] = movie.toString();

    prefs.setString(DataStorageKey.details.name, json.encode(movies));
  }

  dynamic getDetailsMovie({bool all = false, int? movieId}) {
    if (all) {
      return json.decode(prefs.getString(DataStorageKey.details.name) ?? '{}');
    } else if (movieId != null) {
      Map<String, dynamic> movies =
          json.decode(prefs.getString(DataStorageKey.details.name) ?? '{}');

      return MovieDetailsModel.fromMap(json.decode(movies["$movieId"] ?? '{}'));
    } else {
      return null;
    }
  }
}
