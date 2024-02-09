import 'dart:io';

import 'package:movie_app/src/data/api/api_repository_interface.dart';
import 'package:movie_app/src/data/models/genre/genre_model.dart';
import 'package:movie_app/src/data/models/movie/movie_model.dart';
import 'package:movie_app/src/models/error_model.dart';
import 'package:movie_app/src/services/api_service.dart';
import 'package:movie_app/src/storage/data_storage.dart';

class ApiRepository extends ApiRepositoryInterface {
  ApiRepository(this.datasource);
  final ApiService datasource;

  Future<bool> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Future<(ErrorModel?, List<GenreModel>?)> getCats() async {
    final bool connection = await _checkConnection();

    final Storage storage = Storage();
    if (connection) {
      final Map<String, dynamic> response = await datasource.getCats();
      try {
        if (response['statusCode'] != HttpStatus.ok) {
          return (ErrorModel(response['message']), null);
        }

        storage.saveGenre(movies: response['data'] as List<GenreModel>);

        return (null, response['data'] as List<GenreModel>);
      } catch (_) {
        return (ErrorModel("Error al obtener los generos"), null);
      }
    } else {
      final List<GenreModel> genreSaved = storage.getGenreModel();

      if (genreSaved.isEmpty) {
        return (ErrorModel("No hay generos almacenados"), null);
      } else {
        return (null, genreSaved);
      }
    }
  }

  @override
  Future<(ErrorModel?, List<GenreModel>?)> getCatsTv() async {
    final bool connection = await _checkConnection();

    final Storage storage = Storage();
    if (connection) {
      final Map<String, dynamic> response = await datasource.getCatsTv();
      try {
        if (response['statusCode'] != HttpStatus.ok) {
          return (ErrorModel(response['message']), null);
        }

        storage.saveGenre(tv: response['data'] as List<GenreModel>);

        return (null, response['data'] as List<GenreModel>);
      } catch (_) {
        return (ErrorModel("Error al obtener los generos"), null);
      }
    } else {
      final List<GenreModel> genreSaved = storage.getGenreModel(tv: true);

      if (genreSaved.isEmpty) {
        return (ErrorModel("No hay generos almacenados"), null);
      } else {
        return (null, genreSaved);
      }
    }
  }

  @override
  Future<(ErrorModel?, MovieDetailsModel?)> getDetails(int id,
      {bool isMovie = true}) async {
    final bool connection = await _checkConnection();

    final Storage storage = Storage();
    if (connection) {
      final Map<String, dynamic> response =
          await datasource.getDetails(id, isMovie: isMovie);
      try {
        if (response['statusCode'] != HttpStatus.ok) {
          return (ErrorModel(response['message']), null);
        }

        storage.saveDetails(id, response['data'] as MovieDetailsModel);

        return (null, response['data'] as MovieDetailsModel);
      } catch (_) {
        return (ErrorModel("Error al obtener los generos"), null);
      }
    } else {
      final MovieDetailsModel movieDetails =
          storage.getDetailsMovie(movieId: id);

      if (movieDetails.id == null) {
        return (ErrorModel("No hay detalles almacenados"), null);
      } else {
        return (null, movieDetails);
      }
    }
  }

  @override
  Future<(ErrorModel?, List<MovieModel>?)> getMoviesTVList(
      {List<String>? genres,
      int page = 1,
      String? search,
      bool isMovie = true}) async {
    final bool connection = await _checkConnection();
    final Storage storage = Storage();
    if (connection) {
      final Map<String, dynamic> response = await datasource.getMoviesTVList(
          genres: genres, isMovie: isMovie, page: page, search: search);
      try {
        if (response['statusCode'] != HttpStatus.ok) {
          return (ErrorModel(response['message']), null);
        }

        storage.saveMoviesPerPage(page, response['data'] as List<MovieModel>);

        return (null, response['data'] as List<MovieModel>);
      } catch (_) {
        return (ErrorModel("Error al obtener las películas"), null);
      }
    } else {
      final List<MovieModel> moviesSaved = storage.getMoviesPerPage(page: page);

      if (moviesSaved.isEmpty) {
        return (ErrorModel("No hay películas almacenadas"), null);
      } else {
        return (null, moviesSaved);
      }
    }
  }
}
