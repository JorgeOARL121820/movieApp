import 'dart:io';

import 'package:movie_app/src/data/models/genre/genre_model.dart';
import 'package:movie_app/src/data/models/movie/movie_model.dart';
import 'package:movie_app/src/utils/utils.dart';

class ApiService {
  Future<Map<String, dynamic>> getMoviesTVList(
      {List<String>? genres,
      int page = 1,
      String? search,
      bool isMovie = true}) async {
    final Map<String, dynamic> apiResponse = await Api.call(
      search != null && search != ''
          ? '/search/${isMovie ? 'movie' : 'tv'}?page=$page&language=es&include_adult=false&query=$search'
          : '/discover/${isMovie ? 'movie' : 'tv'}?language=es&include_adult=false&page=$page${(genres?.isNotEmpty ?? false) ? "&with_genres=${genres?.join(',')}" : ''}',
    );

    final bool isSuccess = apiResponse['statusCode'] == HttpStatus.ok;

    return <String, dynamic>{
      ...apiResponse,
      "data": isSuccess
          ? ((apiResponse['data'] as Map<String, dynamic>)['results']
                  as List<dynamic>)
              .map((dynamic movies) =>
                  MovieModel.fromMap(movies as Map<String, dynamic>))
              .toList()
          : apiResponse['data'],
    };
  }

  Future<Map<String, dynamic>> getDetails(int id, {bool isMovie = true}) async {
    final Map<String, dynamic> apiResponse = await Api.call(
      '/${isMovie ? 'movie' : 'tv'}/$id?language=es',
    );

    final bool isSuccess = apiResponse['statusCode'] == HttpStatus.ok;

    if (isSuccess) {
      (apiResponse['data'] as Map<String, dynamic>)['cast'] =
          await _getCastDetails(id, isMovie: isMovie);
    }

    return <String, dynamic>{
      ...apiResponse,
      "data": isSuccess
          ? MovieDetailsModel.fromMap(apiResponse['data'])
          : apiResponse['data'],
    };
  }

  Future<List<dynamic>> _getCastDetails(int movieId,
      {bool isMovie = true}) async {
    final Map<String, dynamic> apiResponse = await Api.call(
      '/${isMovie ? 'movie' : 'tv'}/$movieId/credits?language=es',
    );

    final bool isSuccess = apiResponse['statusCode'] == HttpStatus.ok;

    if (isSuccess) {
      return (apiResponse['data'] as Map<String, dynamic>)['cast'];
    } else {
      return [];
    }
  }

  Future<Map<String, dynamic>> getCats() async {
    final Map<String, dynamic> apiResponse = await Api.call(
      '/genre/movie/list?language=es',
    );

    final bool isSuccess = apiResponse['statusCode'] == HttpStatus.ok;

    return <String, dynamic>{
      ...apiResponse,
      "data": isSuccess
          ? ((apiResponse['data'] as Map<String, dynamic>)['genres']
                  as List<dynamic>)
              .map((dynamic genre) =>
                  GenreModel.fromMap(genre as Map<String, dynamic>))
              .toList()
          : apiResponse['data'],
    };
  }

  Future<Map<String, dynamic>> getCatsTv() async {
    final Map<String, dynamic> apiResponse = await Api.call(
      '/genre/tv/list?language=es',
    );

    final bool isSuccess = apiResponse['statusCode'] == HttpStatus.ok;

    return <String, dynamic>{
      ...apiResponse,
      "data": isSuccess
          ? ((apiResponse['data'] as Map<String, dynamic>)['genres']
                  as List<dynamic>)
              .map((dynamic genre) =>
                  GenreModel.fromMap(genre as Map<String, dynamic>))
              .toList()
          : apiResponse['data'],
    };
  }
}
