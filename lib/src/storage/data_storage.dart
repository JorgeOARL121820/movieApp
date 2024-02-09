import 'dart:convert';

import 'package:movie_app/src/data/models/genre/genre_model.dart';
import 'package:movie_app/src/data/models/movie/movie_model.dart';
import 'package:movie_app/src/utils/utils.dart';

enum DataStorageKey {
  details("ST_Details"),
  moviesPerPage("ST_MOVIES_PP"),
  genreTv("GENRE_TV"),
  genreMovie("GENRE_MOVIE"),
  imagesMovies("ST_IMAGES_MOVIES");

  const DataStorageKey(this.name);
  final String name;
}

class Storage {
  void saveGenre({List<GenreModel>? tv, List<GenreModel>? movies}) {
    if (tv != null) {
      prefs.setString(DataStorageKey.genreTv.name, json.encode(tv));
    } else {
      prefs.setString(DataStorageKey.genreMovie.name, json.encode(movies));
    }
  }

  List<GenreModel> getGenreModel({bool tv = false}) {
    if (tv) {
      return ((json
                  .decode(prefs.getString(DataStorageKey.genreTv.name) ?? '[]'))
              as List<dynamic>)
          .map((dynamic e) => GenreModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } else {
      return ((json.decode(
                  prefs.getString(DataStorageKey.genreMovie.name) ?? '[]'))
              as List<dynamic>)
          .map((dynamic e) => GenreModel.fromMap(e as Map<String, dynamic>))
          .toList();
    }
  }

  void saveImage(int movieId, String imageB64) {
    final Map<String, dynamic> images = getImage(allImages: true);

    images["$movieId"] = imageB64;

    prefs.setString(DataStorageKey.imagesMovies.name, json.encode(images));
  }

  dynamic getImage({bool allImages = false, int? movieId}) {
    if (allImages) {
      return json
          .decode(prefs.getString(DataStorageKey.imagesMovies.name) ?? '{}');
    } else if (movieId != null) {
      final Map<String, dynamic> images = json
          .decode(prefs.getString(DataStorageKey.imagesMovies.name) ?? '{}');

      return images['$movieId'];
    } else {
      return null;
    }
  }

  void saveMoviesPerPage(int page, List<MovieModel> movies) {
    final Map<String, dynamic> movies = getMoviesPerPage(allPages: true);

    movies["$page"] = movies;

    prefs.setString(DataStorageKey.details.name, json.encode(movies));
  }

  dynamic getMoviesPerPage({bool allPages = false, int? page}) {
    if (allPages) {
      return json
          .decode(prefs.getString(DataStorageKey.moviesPerPage.name) ?? '{}');
    } else if (page != null) {
      final Map<String, dynamic> moviesPerPage = json
          .decode(prefs.getString(DataStorageKey.moviesPerPage.name) ?? '{}');

      return (moviesPerPage["$page"] as List<dynamic>)
          .map((dynamic e) => MovieModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } else {
      return null;
    }
  }

  Future<void> saveDetails(int movieId, MovieDetailsModel movie) async {
    final Map<String, dynamic> movies = getDetailsMovie(all: true);

    movies["$movieId"] = movie;

    prefs.setString(DataStorageKey.details.name, json.encode(movies));
  }

  dynamic getDetailsMovie({bool all = false, int? movieId}) {
    if (all) {
      return json.decode(prefs.getString(DataStorageKey.details.name) ?? '{}');
    } else if (movieId != null) {
      Map<String, dynamic> movies =
          json.decode(prefs.getString(DataStorageKey.details.name) ?? '{}');

      return MovieDetailsModel.fromMap(movies["$movieId"]);
    } else {
      return null;
    }
  }
}
