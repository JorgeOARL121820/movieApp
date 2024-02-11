import 'dart:io';

import 'package:movie_app/src/data/api/enum/api_movie_type.dart';
import 'package:movie_app/src/data/models/account/account_model.dart';
import 'package:movie_app/src/data/models/genre/genre_model.dart';
import 'package:movie_app/src/data/models/movie/movie_model.dart';
import 'package:movie_app/src/models/error_model.dart';

abstract class ApiRepositoryInterface {
  Future<(ErrorModel?, List<MovieModel>?)> getMoviesList(
      {required MovieCatType type,
      List<int>? genres,
      int page = 1,
      String? search});

  Future<(ErrorModel?, MovieDetailsModel?)> getDetails(int id);

  Future<(ErrorModel?, List<GenreModel>?)> getCats();
  Future<(ErrorModel?, AccountModel?)> getAccountInfo();
  Future<(ErrorModel?, String?)> saveFile(File file);
  Future<(ErrorModel?, List<String>?)> getAllFiles();
}
