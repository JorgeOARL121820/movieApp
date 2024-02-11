import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:movie_app/src/data/api/enum/api_movie_type.dart';
import 'package:movie_app/src/data/models/account/account_model.dart';
import 'package:movie_app/src/data/models/genre/genre_model.dart';
import 'package:movie_app/src/data/models/movie/movie_model.dart';
import 'package:movie_app/src/utils/utils.dart';

class ApiService {
  Future<Map<String, dynamic>> getMoviesList(
      {required MovieCatType type,
      List<int>? genres,
      int page = 1,
      String? search}) async {
    String url = '';

    switch (type) {
      case MovieCatType.upcoming:
        url = '/movie/upcoming?language=es&include_adult=false';
      case MovieCatType.topRated:
        url = '/movie/top_rated?language=es&include_adult=false';
      case MovieCatType.popular:
        url = '/movie/popular?language=es&include_adult=false';
      case MovieCatType.nowPlaying:
        url = '/movie/now_playing?language=es&include_adult=false';
      case MovieCatType.general:
        url = search != null && search != ''
            ? '/search/movie?page=$page&language=es&include_adult=false&query=$search'
            : '/discover/movie?language=es&include_adult=false&page=$page${(genres?.isNotEmpty ?? false) ? "&with_genres=${genres?.join(',')}" : ''}';
    }

    final Map<String, dynamic> apiResponse = await Api.call(
      url,
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

  Future<Map<String, dynamic>> getDetails(int id) async {
    final Map<String, dynamic> apiResponse = await Api.call(
      '/movie/$id?language=es',
    );

    final bool isSuccess = apiResponse['statusCode'] == HttpStatus.ok;

    if (isSuccess) {
      (apiResponse['data'] as Map<String, dynamic>)['cast'] =
          await _getCastDetails(id);
    }

    return <String, dynamic>{
      ...apiResponse,
      "data": isSuccess
          ? MovieDetailsModel.fromMap(apiResponse['data'])
          : apiResponse['data'],
    };
  }

  Future<List<dynamic>> _getCastDetails(int movieId) async {
    final Map<String, dynamic> apiResponse = await Api.call(
      '/movie/$movieId/credits?language=es',
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

  Future<Map<String, dynamic>> getAccount() async {
    final Map<String, dynamic> apiResponse = await Api.call(
      '/account/20976270',
    );

    final bool isSuccess = apiResponse['statusCode'] == HttpStatus.ok;

    return <String, dynamic>{
      ...apiResponse,
      "data": isSuccess
          ? AccountModel(
              avatar_path: apiResponse['data']['avatar']['tmdb']['avatar_path'],
              id: apiResponse['data']['id'],
              include_adult: apiResponse['data']['include_adult'],
              iso_3166_1: apiResponse['data']['iso_3166_1'],
              iso_639_1: apiResponse['data']['iso_639_1'],
              name: apiResponse['data']['name'],
              username: apiResponse['data']['username'])
          : apiResponse['data'],
    };
  }

  Future<Map<String, dynamic>> uploadFile(File file) async {
    final storageRef =
        FirebaseStorage.instanceFor(bucket: "gs://test-e92c3.appspot.com")
            .ref();

    final images = storageRef.child("images");

    final imageRef = images.child(file.path.split('/').last);

    try {
      await imageRef.putFile(file);
      return {"statusCode": 200, "data": true, "message": "File upload"};
    } catch (_) {
      return {"statusCode": 500, "data": _.toString(), "message": ""};
    }
  }

  Future<List<String>> getAllFilesUpload() async {
    final storageRef = FirebaseStorage.instance.ref().child("images");

    final ListResult listResult = await storageRef.listAll();

    return listResult.items.map((Reference e) => e.name).toList();
  }
}
