import 'dart:io';

import 'package:movie_app/src/data/api/api_repository_interface.dart';
import 'package:movie_app/src/data/api/enum/api_movie_type.dart';
import 'package:movie_app/src/data/models/account/account_model.dart';
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
  Future<(ErrorModel?, MovieDetailsModel?)> getDetails(
    int id,
  ) async {
    final bool connection = await _checkConnection();

    final Storage storage = Storage();

    if (connection) {
      final Map<String, dynamic> response = await datasource.getDetails(id);
      try {
        if (response['statusCode'] != HttpStatus.ok) {
          return (ErrorModel(response['message']), null);
        }

        storage.saveDetails(id, response['data'] as MovieDetailsModel);

        return (null, response['data'] as MovieDetailsModel);
      } catch (_) {
        return (ErrorModel("Error al obtener el detalle de la película"), null);
      }
    } else {
      final MovieDetailsModel? movies = storage.getDetailsMovie(movieId: id);

      if (movies?.id == null) {
        return (ErrorModel("Error al obtener el detalle de la película"), null);
      } else {
        return (null, movies);
      }
    }
  }

  @override
  Future<(ErrorModel?, List<MovieModel>?)> getMoviesList(
      {required MovieCatType type,
      List<int>? genres,
      int page = 1,
      String? search}) async {
    final bool connection = await _checkConnection();
    final Storage storage = Storage();
    if (connection) {
      final Map<String, dynamic> response = await datasource.getMoviesList(
          type: type, genres: genres, page: page, search: search);
      try {
        if (response['statusCode'] != HttpStatus.ok) {
          return (ErrorModel(response['message']), null);
        }

        switch (type) {
          case MovieCatType.general:
            storage.saveMoviesPerPage(
                page, response['data'] as List<MovieModel>);

          case MovieCatType.nowPlaying:
          case MovieCatType.popular:
          case MovieCatType.topRated:
          case MovieCatType.upcoming:
            storage.saveMovies(response['data'] as List<MovieModel>, type);
        }

        return (null, response['data'] as List<MovieModel>);
      } catch (_) {
        return (ErrorModel("Error al obtener las películas"), null);
      }
    } else {
      List<MovieModel> movies = <MovieModel>[];

      switch (type) {
        case MovieCatType.general:
          movies = storage.getMoviesPerPage(page: page);

        case MovieCatType.nowPlaying:
        case MovieCatType.popular:
        case MovieCatType.topRated:
        case MovieCatType.upcoming:
          movies = storage.getMovies(type);
      }

      if (movies.isEmpty) {
        return (ErrorModel("Error al obtener las películas"), null);
      } else {
        return (null, movies);
      }
    }
  }

  @override
  Future<(ErrorModel?, AccountModel?)> getAccountInfo() async {
    final bool connection = await _checkConnection();
    final Storage storage = Storage();
    if (connection) {
      final Map<String, dynamic> response = await datasource.getAccount();
      try {
        if (response['statusCode'] != HttpStatus.ok) {
          return (ErrorModel(response['message']), null);
        }

        storage.saveAccount(response['data'] as AccountModel);

        return (null, response['data'] as AccountModel);
      } catch (_) {
        return (ErrorModel("Error al obtener las películas"), null);
      }
    } else {
      final AccountModel? moviesSaved = storage.getAccount();

      if (moviesSaved != null) {
        return (ErrorModel("No hay información almacenada"), null);
      } else {
        return (null, moviesSaved);
      }
    }
  }

  @override
  Future<(ErrorModel?, List<String>?)> getAllFiles() async {
    final List<String> response = await datasource.getAllFilesUpload();
    try {
      return (null, response);
    } catch (_) {
      return (ErrorModel("Error al consultar las imagenes"), null);
    }
  }

  @override
  Future<(ErrorModel?, String?)> saveFile(File file) async {
    final Map<String, dynamic> response = await datasource.uploadFile(file);
    try {
      if (response['statusCode'] != HttpStatus.ok) {
        return (ErrorModel(response['data']), null);
      }

      return (null, response['message'].toString());
    } catch (_) {
      return (ErrorModel("Error al obtener las películas"), null);
    }
  }
}
