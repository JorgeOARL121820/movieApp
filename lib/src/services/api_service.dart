import 'dart:io';

class ApiService {
  Future<Map<String, dynamic>> getMoviesList({String? cat}) async {
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>> getCats() async {
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>> getDetailsMovie(
      {required String movieId}) async {
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>> getDetailsActor(
      {required String actorId}) async {
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>> getMoviesByActorId(
      {required String actorId}) async {
    throw UnimplementedError();
  }
}
